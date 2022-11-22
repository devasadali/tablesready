class AddColumnCanSendAbandomentEmailToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :can_send_abandoment_email, :boolean,default: false
  end
end
