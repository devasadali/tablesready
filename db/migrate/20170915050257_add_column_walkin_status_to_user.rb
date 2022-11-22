class AddColumnWalkinStatusToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :walkin_status, :integer,default: 0
  end
end
