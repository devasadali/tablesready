class BookingBroadcastJob < ApplicationJob
  queue_as :default

  rescue_from(ActiveRecord::RecordNotFound) do |exception|
    # Do something with the exception
  end

  def perform(booking)
    puts "In perform!"
    booking.auto_no_show
  end
 
end
