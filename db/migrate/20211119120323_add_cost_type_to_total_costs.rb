class AddCostTypeToTotalCosts < ActiveRecord::Migration[6.1]
  def change
    add_column :total_costs, :cost_type_id, :integer, {null: true, comment: "原価種別"}
  end
end
