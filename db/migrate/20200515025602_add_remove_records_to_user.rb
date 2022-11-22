class AddRemoveRecordsToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :remove_records, :boolean, default: false
  end
end
