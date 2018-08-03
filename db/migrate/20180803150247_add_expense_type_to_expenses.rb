class AddExpenseTypeToExpenses < ActiveRecord::Migration[5.2]
  def change
    add_column :expenses, :expense_type_id, :integer, {null: false, default: 0, comment: "経費種別"}
  end
end
