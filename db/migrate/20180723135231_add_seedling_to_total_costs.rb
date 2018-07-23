class AddSeedlingToTotalCosts < ActiveRecord::Migration[5.2]
  def change
    add_column :total_costs, :seedling_home_id, :integer, {null: true, comment: "育苗担当"}
  end
end
