class RemoveAccountInfo < ActiveRecord::Migration[8.0]
  def up
    remove_column :organizations, :account_type_id
    remove_column :organizations, :bank_code
    remove_column :organizations, :branch_code
    remove_column :organizations, :account_number
    remove_column :workers, :account_type_id
    remove_column :workers, :bank_code
    remove_column :workers, :branch_code
    remove_column :workers, :account_number
  end

  def down
    add_column :organizations, :account_type_id, :integer, default: 0, null: false, comment: "口座種別"
    add_column :organizations, :bank_code, :string, limit: 4, default: '0000', null: false, comment: "銀行コード"
    add_column :organizations, :branch_code, :string, limit: 3, default: '000', null: false, comment: "支店コード"
    add_column :organizations, :account_number, :string, limit: 7, default: '0000000', null: false, comment: "口座番号"
    add_column :workers, :account_type_id, :integer, default: 0, null: false, comment: "口座種別"
    add_column :workers, :bank_code, :string, limit: 4, default: '0000', null: false, comment: "銀行コード"
    add_column :workers, :branch_code, :string, limit: 3, default: '000', null: false, comment: "支店コード"
    add_column :workers, :account_number, :string, limit: 7, default: '0000000', null: false, comment: "口座番号"
  end
end
