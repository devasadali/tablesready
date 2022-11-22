class AddColumnNextDelayToMessageTemplates < ActiveRecord::Migration[5.1]
  def change
    add_column :message_templates, :next_delay, :integer,default: 5
  end
end
