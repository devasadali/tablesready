class AddColumnSequenceInProgressToBookings < ActiveRecord::Migration[5.1]
  def change
    add_column :bookings, :sequence_in_progress, :boolean,default: false
  end
end
