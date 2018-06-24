class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses, {comment: "経費"} do |t|
      t.integer :term, {limit: 4, null: false, comment: "年度(期)"}
      t.date :payed_on, {null: false, comment: "支払日"}
      t.string :content, {limit: 40, null: false, comment: "支払内容"}
      t.decimal :amount, {scale: 0, precision: 7, null: false, default: 0, comment: "支払金額"}

      t.timestamps null: false
    end
  end
end
