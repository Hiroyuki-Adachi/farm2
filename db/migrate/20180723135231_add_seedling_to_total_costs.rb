class AddSeedlingToTotalCosts < ActiveRecord::Migration[5.2]
  def change
    add_column :total_costs, :seedling_home_id, :integer, {null: true, comment: "育苗担当"}
    add_column :total_costs, :member_flag, :boolean, {null: false, default: false, comment: "組合員支払フラグ"}
    add_column :lands, :reg_area, :decimal, {scale: 2, precision: 5, null: true, comment: "登記面積"}

    ActiveRecord::Base.connection.execute("UPDATE lands SET reg_area = area + 0.6")
  end
end
