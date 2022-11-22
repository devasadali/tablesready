class ChangeApprovedColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :message_templates, :approved?, :approved
  end
end
