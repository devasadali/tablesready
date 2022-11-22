class AddColumnTrialExtendedToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :trial_extended, :boolean,default: false
  end
end
