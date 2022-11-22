class AddColumnsLowerAndUpperLimitToPlans < ActiveRecord::Migration[5.1]
  def change
    add_column :plans, :lower_limit, :integer
    add_column :plans, :upper_limit, :integer
  end
end
