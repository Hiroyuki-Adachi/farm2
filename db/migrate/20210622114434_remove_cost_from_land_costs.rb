class RemoveCostFromLandCosts < ActiveRecord::Migration[6.1]
  def up
    remove_column :land_costs, :cost
  end

  def down
    add_column :land_costs, :cost, :decimal, {scale: 1, precision: 7, null: false, default: 0, comment: "原価"}
  end
end
