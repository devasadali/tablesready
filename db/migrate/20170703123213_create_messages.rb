class CreateMessages < ActiveRecord::Migration[5.1]
  def change
    create_table :messages do |t|
      t.integer :restaurant_id
      t.text :template
      t.string :recipent
      t.integer :message_type, default: 0

      t.timestamps
    end
  end
end
