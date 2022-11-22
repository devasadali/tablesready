class AddColumnMarketingMessageableToCustomers < ActiveRecord::Migration[5.1]
  def change
    add_column :customers, :marketing_messageable, :boolean,default: true
  end
end
