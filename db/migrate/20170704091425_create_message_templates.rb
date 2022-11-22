class CreateMessageTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :message_templates do |t|
      t.string :name
      t.text :template
      t.integer :sort_order
      t.integer :restaurant_id

      t.timestamps
    end
  end
end
