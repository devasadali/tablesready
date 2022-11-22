class MailchimpSubscribeJob < ApplicationJob
  queue_as :default

  def perform(user, subscription, subscribe = true, cancel = false)
    MailchimpSubscribeService.new.call(user, subscription, subscribe, cancel)
  end
end
