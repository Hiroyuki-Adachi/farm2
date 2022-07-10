class CreateSorimachiAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :sorimachi_accounts, comment: "ソリマチ勘定科目" do |t|
      t.integer :term,    limit: 4, null: false, comment: "年度(期)"
      t.integer :code,  null: false, default: 0, comment: "科目コード"
      t.string  :name,  null: false, default: "", comment: "名称"
      t.integer :total_cost_type_id, null: false, default: 0, comment: "原価種別"
      t.integer :auto_code, null: true, comment: "自動設定コード"
      t.integer :auto_work_type_id, null: true, comment: "自動設定作業分類"

      t.timestamps
    end
    add_index :sorimachi_accounts, [:term, :code], unique: true, name: "sorimachi_accounts_2nd"
  end
end
