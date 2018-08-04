class AddExpenseTypeToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :expense_type_id, :integer, {null: false, default: 0, comment: "経費種別"}
    add_column :expenses, :quantity, :decimal, {scale: 0, precision: 4, null: true, comment: "数量"}
    add_column :expenses, :discount, :decimal, {scale: 0, precision: 7, null: true, comment: "割引額"}
    add_column :expenses, :discount_numor, :decimal, {scale: 0, precision: 7, null: true, comment: "割引率(分子)"}
    add_column :expenses, :discount_denom, :decimal, {scale: 0, precision: 7, null: true, comment: "割引率(分母)"}
    add_column :expenses, :cost_flag, :boolean, {null: false, default: false, comment: "支払時原価フラグ"}
    change_column :expenses, :content, :string, {limit: 40, null: true, comment: "支払内容"}
    change_column :expenses, :chemical_type_id, :integer, {null: true, comment: "薬剤種別"}
  end
end
