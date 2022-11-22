class AddColumnMarketingStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :marketing_status, :integer,default: 0
  end
end
