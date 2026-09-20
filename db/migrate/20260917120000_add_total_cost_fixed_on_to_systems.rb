class AddTotalCostFixedOnToSystems < ActiveRecord::Migration[8.1]
  def change
    add_column :systems, :total_cost_fixed_on, :date, comment: "原価計算済み締め日"
  end
end
