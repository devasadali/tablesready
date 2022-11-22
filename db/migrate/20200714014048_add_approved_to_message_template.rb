class AddApprovedToMessageTemplate < ActiveRecord::Migration[5.1]
  def change
    add_column :message_templates, :approved?, :boolean, default: false
    MessageTemplate.update_all(approved?: true)
  end
end
