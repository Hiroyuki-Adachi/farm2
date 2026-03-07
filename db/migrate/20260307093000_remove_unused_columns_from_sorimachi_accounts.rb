class RemoveUnusedColumnsFromSorimachiAccounts < ActiveRecord::Migration[8.1]
  def change
    remove_column :sorimachi_accounts, :cost_flag, :boolean
    remove_column :sorimachi_accounts, :auto_code, :integer
    remove_column :sorimachi_accounts, :auto_work_type_id, :integer
  end
end
