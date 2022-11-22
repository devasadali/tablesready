# app/channels/messages_channel.rb
class MessageSequenceChannel < ApplicationCable::Channel  
  def subscribed
    stream_from 'message_sequence'
  end
end  