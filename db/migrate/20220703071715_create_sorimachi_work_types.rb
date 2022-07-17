class CreateSorimachiWorkTypes < ActiveRecord::Migration[7.0]
  def change
    create_table :sorimachi_work_types, comment: "ソリマチ作業分類" do |t|
      t.integer :sorimachi_journal_id, null: false, default: 0, comment: "ソリマチ仕訳"
      t.integer :work_type_id, null: false, default: 0, comment: "作業分類"
      t.decimal :amount, scale: 0, precision: 7, null: false, default: 0, comment: "内訳金額"

      t.timestamps
    end
    add_index :sorimachi_work_types, [:sorimachi_journal_id, :work_type_id], unique: true, name: "sorimachi_work_types_2nd"
  end
end
