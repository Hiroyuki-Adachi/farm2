class AddSeedlingToTotalCosts < ActiveRecord::Migration[5.2]
  def change
    add_column :total_costs, :seedling_home_id, :integer, {null: true, comment: "育苗担当"}
    add_column :total_costs, :member_flag, :boolean, {null: false, default: false, comment: "組合員支払フラグ"}
  end
end
