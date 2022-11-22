class AddColumnNoShowThresholdToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :no_show_threshold, :integer,default: 30
  end
end
