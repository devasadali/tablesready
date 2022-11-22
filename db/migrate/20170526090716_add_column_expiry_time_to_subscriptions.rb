class AddColumnExpiryTimeToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :expired_at, :datetime
  end
end
