class AddColumnsWaitTimeAndCustomerIdToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :wait_in_minutes, :integer,default: 0
    add_column :bookings, :customer_id, :integer
  end
end
