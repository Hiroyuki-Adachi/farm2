class CreateExpenseType < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_types, comment: "経費種別" do |t|
      t.string :name, {limit: 10, null: false, default: "", comment: "経費種別名称"}
      t.boolean :chemical_flag, {null: false, default: false, comment: "薬剤フラグ"}
      t.boolean :sales_flag, {null: false, default: false, comment: "売上フラグ"}
      t.boolean :other_flag, {null: false, default: false, comment: "その他フラグ"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps
      t.datetime :deleted_at, {null: true, comment: "削除年月日"}
    end
    ExpenseType.create(name: "種苗", display_order: 10)
    ExpenseType.create(name: "薬品", display_order: 20, chemical_flag: true)
    ExpenseType.create(name: "燃料", display_order: 30)
    ExpenseType.create(name: "機械", display_order: 40)
    ExpenseType.create(name: "梱包", display_order: 50)
    ExpenseType.create(name: "水道光熱", display_order: 110)
    ExpenseType.create(name: "通信", display_order: 130)
    ExpenseType.create(name: "事務", display_order: 140)
    ExpenseType.create(name: "その他", display_order: 199, other_flag: true)
    ExpenseType.create(name: "売上", display_order: 201, sales_flag: true)
    ExpenseType.create(name: "助成金", display_order: 210, sales_flag: true)
    ExpenseType.all.each do |expense_type|
      Expense.where(expense_type_id: expense_type.display_order).update_all(expense_type_id: expense_type.id)
    end
  end
end
