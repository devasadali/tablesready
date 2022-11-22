require 'stripe_box'
class User < ApplicationRecord
  include StripeBox

  has_many :subscriptions

  enum role: [:user, :restaurant, :admin]
  enum walkin_status: [:nonavailed,:trial,:paid,:cancelled]
  enum marketing_status: [:unavailed,:marketing,:unsubscribed]
  after_initialize :set_default_role, :if => :new_record?
  after_create :set_trial_mode
  belongs_to :restaurant
  belongs_to :country

  accepts_nested_attributes_for :restaurant

  scope :in_trial, -> {where(in_trial: true)}


  def first_name
    name.split(" ").first
  end

  def last_name
    name.split(" ").last
  end

  def set_default_role
    self.role ||= :user
  end

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,:confirmable, :async

  def trial_expired?
    expired = false
    if self.trial_ends_at < Time.now
      expired = true
    end
    expired
  end

  def trial_availed?
    return true if trial_expired?
    return true if !in_trial
    return false
  end

  def valid_subscription
    if in_trial and !trial_expired?
      return true
    else
      has_subscription?
    end
  end

  def subscribe plan_id,type="walkin"
    begin
      if self.has_subscription?(type)
        response = existing_subscription(plan_id,type)
      else
        response = new_subscription(plan_id,type)
      end
      unless response[:error]
        send_subscription_email(response[:sub])
        subscribe_mailchimp_list(response[:sub])
      end
    rescue Exception => e
      puts "================= Exception User::subscribe ================="
      puts e.message
      response = { error: true, message: e.message}
    end

    return response
  end

  ###########################################
  ########### current subscription ##########
  ### @param type eg.(walkin,marketing)
  ### default @params: walkin
  ### returns: last subscription or nil
  ###########################################
  def current_subscription type="walkin"
    subscriptions.send(type).last
  end

  def has_subscription? type="walkin"
    current_subscription(type).present?
  end

  def trial_availed!
    self.in_trial = false
    self.save
  end

  def can_send_marketing_messages?
    subscription = self.subscriptions.last
    return false if subscription.nil?
    restaurant = self.restaurant
    start_date = subscription.updated_at.beginning_of_day
    end_date = subscription.updated_at.end_of_day + 30.days
    message_sent_count = restaurant.marketing_messages_count(start_date,end_date)
    return message_sent_count < total_message_credits(subscription)
  end

  def total_message_credits subscription
    return 0 if subscription.nil?
    plan = subscription.plan
    plan.upper_limit
  end

  def remaining_messages_credits
    subscription = self.subscriptions.last
    return 0 if subscription.nil?
    restaurant = self.restaurant
    start_date = subscription.updated_at.beginning_of_day
    end_date = subscription.updated_at.end_of_day + 30.days
    total_credits = total_message_credits(subscription)
    restaurant.remaining_messages_credits(total_credits,start_date,end_date)
  end

  def send_subscription_email(subscription)
    UserMailer.subscription_auto_email(self,subscription).deliver_later
  end

  def no_subscription_email
    self.update_attributes(in_trial: false)
    UserMailer.non_subscriber_email(self).deliver_later
  end

  def subscribe_mailchimp_list(subscription)
    MailchimpSubscribeJob.perform_later(self, subscription, true, false)
  end

  def cancel_subscription(cancel)
    MailchimpSubscribeJob.perform_later(self, nil, true, cancel)
  end

  def update_subscriptions_cc
    response = get_default_card(self.stripe_customer_id)
    unless response[:error]
      @card = response[:card]
      begin
        self.subscriptions.where.not(subs_type: 'Trial').each do |subscription|
          result = update_subscription_cc(self.stripe_customer_id, subscription)
          stripe_sub = result[:sub]
          subscription.update_attributes(stripe_id: stripe_sub.id, card_type: @card.brand, last_four: @card.last4)
        end
        response = { error: false, message: 'Your card is successfully updated.'}
      rescue Exception => e
        puts "================= Exception User::Update CC ================="
        puts e.message
        response = { error: true, message: e.message}
      end
    end
  end

  private
  def set_trial_mode
    # don't subscribe in trial mode, if user can't avail trial
    return true unless self.can_avail_trial
    self.update(walkin_status: 'trial',in_trial:true,trial_ends_at: Time.now + ENV["TRIAL_PERIOD_DAYS"].to_i.days)
    self.subscriptions.create(in_trial: true,started_at: Time.now,expired_at: self.trial_ends_at,current_price: 0,plan_id: Plan.first.try(:id),status: "Trial",subs_type: Yetting.subscription_types["trial"])
    send_subscription_email(self.subscriptions.last)
    subscribe_mailchimp_list(self.subscriptions.last)
  end

  def new_subscription plan_id,type
    @plan = Plan.get_plan(plan_id)
    response = get_default_card(self.stripe_customer_id)
    unless response[:error]
      @card = response[:card]
      ## Create Subscription
      trial_availed = true
      @stripe_sub = create_subscription(self.stripe_customer_id, plan_id, trial_availed,self)
      if @stripe_sub[:error]
        response = @stripe_sub
      else
        trial_availed! if type == "walkin"
        @stripe_sub = @stripe_sub[:sub]
        @subscription = Subscription.create(stripe_id: @stripe_sub.id,
                        user_id: self.id,
                        started_at: DateTime.strptime(@stripe_sub.current_period_start.to_s,'%s'),
                        expired_at: DateTime.strptime(@stripe_sub.current_period_end.to_s,'%s'),
                        status: @stripe_sub.status,
                        plan_id: @plan.id,
                        card_type: @card.brand,
                        last_four: @card.last4,
                        subs_type: Yetting.subscription_types[type],
                        in_trial: false
                        )
        if type == "walkin"
          msg = "You are subscribed to #{@plan.name} successfully!"
        else
          msg = "An addon #{@plan.name} has been added."
        end
        response = { error: false, sub: @subscription,message: msg}
      end
    end
    response
  end

  def existing_subscription plan_id,type
    @plan = Plan.get_plan(plan_id)
    response = get_default_card(self.stripe_customer_id)
    # todo
    unless response[:error]
      subscription = current_subscription(type)
      @card = response[:card]
      @stripe_sub = update_subscription(subscription.stripe_id,plan_id )
      if @stripe_sub[:error]
        response = @stripe_sub
      else
        @stripe_sub = @stripe_sub[:sub]
        subscription.update_attributes(stripe_id: @stripe_sub.id, 
                                        started_at: DateTime.strptime(@stripe_sub.current_period_start.to_s,'%s'),
                                        expired_at: DateTime.strptime(@stripe_sub.current_period_end.to_s,'%s'),
                                        status: @stripe_sub.status,
                                        plan_id: @plan.id,
                                        card_type: @card.brand,
                                        last_four: @card.last4,
                                        subs_type: Yetting.subscription_types[type],
                                        in_trial: false
                                      )
        response = { error: false, sub: subscription,message: "#{ @plan.walkin? ? 'Subscription' : 'An addon'} has been updated to #{@plan.name}."}
      end
    end
    response
  end
end
