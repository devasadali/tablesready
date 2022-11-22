class CreateBookings < ActiveRecord::Migration[5.1]
  def change
    create_table :bookings do |t|
      t.date :booking_date
      t.time :booking_time
      t.string :party_name
      t.integer :size
      t.string :phone
      t.text :notes
      t.string :type
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
