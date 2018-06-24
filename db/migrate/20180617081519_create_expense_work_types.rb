class CreateExpenseWorkTypes < ActiveRecord::Migration
  def change
    create_table :expense_work_types, {comment: "経費作業種別"} do |t|
      t.integer :expense_id, {comment: "経費"}
      t.integer :work_type_id, {comment: "作業分類"}
      t.decimal :rate, {scale: 2, precision: 5, null: false, default: 0, comment: "割合"}

      t.timestamps null: false
    end
    add_index :expense_work_types, [:expense_id, :work_type_id], {unique: true}
  end
end
