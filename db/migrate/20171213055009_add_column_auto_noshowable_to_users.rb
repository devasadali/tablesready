class AddColumnAutoNoshowableToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :auto_noshowable, :boolean,default: false
  end
end
