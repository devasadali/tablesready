class AddColumnInTrialToSubscriptions < ActiveRecord::Migration[5.1]
  def change
    add_column :subscriptions, :in_trial, :boolean
  end
end
