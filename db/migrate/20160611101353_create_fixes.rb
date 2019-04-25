class CreateFixes < ActiveRecord::Migration[4.2]
  def change
    create_table :fixes, {id: false, comment: "確定データ"} do |t|
      t.integer :term, {null: false, default: 0, comment: "年度(期)"}
      t.date :fixed_at, {null: false, comment: "確定日"}
      t.integer :works_count, {null: false, comment: "合計作業数"}
      t.integer :hours, {null: false, comment: "合計作業工数"}
      t.decimal :works_amount,    {scale: 0, precision: 8, null: false, comment: "合計作業日当"}
      t.decimal :machines_amount, {scale: 0, precision: 8, null: false, comment: "合計機械利用料"}

      t.timestamps null: false
    end
    execute "ALTER TABLE fixes ADD PRIMARY KEY (term, fixed_at);"
  end
end
