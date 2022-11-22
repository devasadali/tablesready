class AddColumnStatusToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :status, :integer
  end
end
