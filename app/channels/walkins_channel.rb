# app/channels/messages_channel.rb
class WalkinsChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'bookings'
  end
end  