class MailchimpSubscribeService
  MailchimpFailed = Class.new(StandardError)
  def initialize
    if ENV['MAILCHIMP_API_KEY']
      @mailchimp = Gibbon::Request.new(api_key: ENV['MAILCHIMP_API_KEY'], symbolize_keys: true)
      @mailchimp.timeout = 30
      @mailchimp.open_timeout = 30

      @interests = {}
      @mailchimp.lists(ENV["MAILCHIMP_LIST_ID"]).interest_categories(ENV["MAILCHIMP_INTEREST_CATEGORY_ID"]).interests.retrieve.body[:interests].each{ |i| @interests[i[:name]] = i[:id] }
    end
  end

  def call(user, subscription, subscribe = true, cancel = false)
    raise MailchimpFailed.new unless @mailchimp
    status = (subscribe ? 'subscribed' : 'unsubscribed')
    interests = {}

    interests[@interests['Marketing Upgrade']] = user.subscriptions.marketing.count.positive?

    if user.subscriptions.walkin.count.positive?
      interests[@interests['Paid']] = true
      interests[@interests['Trial']] = false
      interests[@interests['Cancelled From Paid']] = false
    else
      interests[@interests['Paid']] = false
      interests[@interests['Trial']] = true if subscription&.trial?
    end

    if cancel == 'walkin'
      interests[@interests['Cancelled From Paid']] = true
      interests[@interests['Trial']] = false
    end

    list(user).upsert(
      body: {
        email_address: user.email,
        status: status,
        merge_fields: {
          FNAME:  user.first_name.to_s,
          LNAME: user.last_name.to_s
        },
        interests: interests
      }
    )
  rescue Gibbon::MailChimpError => e
    raise e
  end

  private

  def list(user)
    @mailchimp.lists(ENV['MAILCHIMP_LIST_ID']).members(Digest::MD5.hexdigest(user.email.downcase))
  end
end