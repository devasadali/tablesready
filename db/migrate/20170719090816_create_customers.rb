class CreateCustomers < ActiveRecord::Migration[5.1]
  def change
    create_table :customers do |t|
      t.string :phone
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
