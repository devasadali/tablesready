class AddMessageDatesToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :message_started_at, :datetime
    add_column :bookings, :message_completed_at, :datetime
  end
end