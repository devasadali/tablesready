require 'twilio-ruby'

class TwilioBox
  def initialize type="one-way"
    @client = Twilio::REST::Client.new(ENV['TWILIO_ACCOUNT_ID'], ENV['TWILIO_AUTH_TOKEN'])
  end

  ######################################
  ## send message method
  ## @params:
  ## recipents = ["+923314946924"]
  ## content = "test message"
  ######################################
  def send_sms recipents,content
    begin
      response = @client.messages.create(
        from: ENV['TWILIO_FROM_NUMBER'],
        to: recipents,
        body: content
      )
      response = {error: false, data: response}
    rescue Exception => e
      response = {error: true, message: e.message}
    end
    response
  end
end