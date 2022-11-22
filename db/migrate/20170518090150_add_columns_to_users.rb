class AddColumnsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :phone, :string
    add_column :users, :restaurant_id, :integer
    add_column :users, :country_id, :integer
  end
end
