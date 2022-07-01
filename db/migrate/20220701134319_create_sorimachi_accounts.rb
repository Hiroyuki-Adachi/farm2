class CreateSorimachiAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :sorimachi_accounts, comment: "ソリマチ勘定科目" do |t|
      t.integer :term,    limit: 4, null: false, comment: "年度(期)"
      t.integer :code,  null: false, default: 0, comment: "科目コード"
      t.string  :name,  null: false, default: "", comment: "名称"

      t.timestamps
    end
    add_index :sorimachi_accounts, [:term, :code], unique: true, name: "sorimachi_accounts_2nd"
  end
end
