class AddColumnStartedAtToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :started_at, :datetime
  end
end
