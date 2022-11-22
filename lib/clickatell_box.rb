require 'rest_client'

class ClickatellBox
  def initialize type="one-way"
    @type = type
    #@authorization = @type == 'one-way' ? ENV['CLICKATELL_ONE_WAY_KEY'] : ENV['CLICKATELL_TWO_WAY_KEY']
    @authorization = ENV['CLICKATELL_TWO_WAY_KEY']
    @headers = {"Content-Type"=> "application/json","Accept"=> "application/json","Authorization"=> @authorization}
    @url = "https://platform.clickatell.com/messages"
  end

  ######################################
  ## send message method
  ## @params:
  ## recipents = ["+923314946924"]
  ## content = "test message"
  ######################################
  def send_sms recipents,content
    begin
      # if @type == 'one-way'
      #   payload = {content: content ,to: recipents}.to_json
      # else
      #   payload = {content: content ,to: recipents,from: ENV['CLICKATELL_FROM_NUMBER']}.to_json
      # end
      payload = {content: content ,to: recipents,from: ENV['CLICKATELL_FROM_NUMBER']}.to_json
      response = RestClient.post(@url, payload, @headers)
      response = {error: false,data: response}
    rescue Exception => e
      response = {error: true, message: e.message}
    end
    response
  end
end