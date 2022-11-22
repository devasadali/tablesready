class AddColumnPlanTypeToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :plan_type, :string
  end
end
