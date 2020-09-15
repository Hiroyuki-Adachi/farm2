class AddBaseUnitToChemicals < ActiveRecord::Migration[6.0]
  def change
    add_column :chemicals, :base_unit_id, :integer, {null: false, default: 0, comment: "基本単位"}
    add_column :chemicals, :base_quantity, :decimal, {cale: 0, precision: 6, null: false, default: 0, comment: "消費数"}
    add_column :chemicals, :carton_unit, :string, {limit: 2, null: false, default: "", comment: "購買単位"}
    add_column :chemicals, :carton_quantity, :decimal, {cale: 0, precision: 6, null: false, default: 0, comment: "購買数"}
  end
end
