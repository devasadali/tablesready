class AddColumnCheckinToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :checkin, :boolean,default: false
  end
end
