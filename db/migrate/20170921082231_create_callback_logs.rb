class CreateCallbackLogs < ActiveRecord::Migration[5.1]
  def change
    create_table :callback_logs do |t|
      t.string :name
      t.text :detail

      t.timestamps
    end
  end
end
