require 'twilio_box'
class Message < ApplicationRecord
  belongs_to :restaurant
  enum message_type: [:text_ready,:marketing]

  scope :by_restaurant, -> (restaurant) {where(restaurant: restaurant)}


  def self.send_sms recipents,content,restaurant,message_type = 'marketing'
    sent_count = 0
    message_sender = TwilioBox.new(message_type)
    recipents.each_slice(100).to_a.each do |phones|
      response = message_sender.send_sms(phones,content)
      puts "response: #{response}"
      unless response[:error]
        # log messages
        sent_count +=1
        Message.create(message_type: message_type,restaurant_id: restaurant.id,template: content,api_message_id: response[:data].uri, recipent: response[:data].to)
        # count will be broad cast only for marketing messages
        # bulk_sms_sent_count(recipents.size,sent_count) if message_type == "marketing"
      end
    end
    if sent_count == 0
      msg = "There is problem to connect message sending server. Please try again."
      response = {error: true,message: msg}
    else
      msg = "Message sent successfully to #{sent_count} customers."
      response = {error: false,message: msg}
    end
    # only broad cast for marketing bulk message
    broad_cast_message_channel(msg,true) if message_type == 'marketing'
    response
  end


  def self.bulk_sms_sent_count total_size,sent_count
    broad_cast_message_channel "Message sent to #{sent_count} out of #{total_size}"
  end

  # broad cast to messages_channel
  def self.broad_cast_message_channel msg,show_modal = false
    ActionCable.server.broadcast 'message_notifications',
      response: {msg: msg,show_modal: show_modal}
  end

  def customer
    Customer.by_phone_and_restaurant(self.phone,self.restaurant).last
  end

end
