class AddChemicalToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :chemical_type_id, :integer, {null: false, default: 0, comment: "薬剤種別"}
    add_column :expenses, :chemical_id, :integer, {null: true, comment: "薬剤"}
    add_column :total_costs, :land_id, :integer, {null: true, comment: "土地"}
    add_column :total_costs, :fiscal_flag, :boolean, {null: false, default: false, comment: "決算期フラグ"}
  end
end
