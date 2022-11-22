class AddColumnSubsTypeToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :subs_type, :string
  end
end
