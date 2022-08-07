class ChangeNameOfSorimachiAccounts < ActiveRecord::Migration[7.0]
  def change
    change_column :sorimachi_accounts, :name, :string, null: false, limit: 10, comment: "名称"
  end
end
