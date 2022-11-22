class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :coupon,optional: true
  belongs_to :plan

  scope :trial, -> {where(subs_type: Yetting.subscription_types["trial"])}
  scope :walkin, -> {where(subs_type: Yetting.subscription_types["walkin"])}
  scope :marketing, -> {where(subs_type: Yetting.subscription_types["marketing"])}
  after_create :set_user_status


  def expired?
    self.expired_at.to_i < Time.now.to_i
  end

  def trial?
    self.subs_type == Yetting.subscription_types["trial"]
  end

  def walkin?
    self.subs_type == Yetting.subscription_types["walkin"]
  end

  def marketing?
    self.subs_type == Yetting.subscription_types["marketing"]
  end

  private
    def set_user_status
      return true if self.trial?
      subscribed_user = self.user
      if self.walkin?
        subscribed_user.paid!
      else
        subscribed_user.marketing!
      end
    end

end
