class AddColumnApiMessageIdToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :api_message_id, :string
  end
end
