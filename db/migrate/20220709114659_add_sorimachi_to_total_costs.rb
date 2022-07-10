class AddSorimachiToTotalCosts < ActiveRecord::Migration[7.0]
  def up
    remove_column :total_costs, :expense_id
    add_column :total_costs, :sorimachi_journal_id, :integer, null: true, comment: "ソリマチ仕訳"
    add_column :total_costs, :sorimachi_account_id, :integer, null: true, comment: "ソリマチ勘定科目"
  end
  
  def down
    remove_column :total_costs, :sorimachi_journal_id
    remove_column :total_costs, :sorimachi_account_id
    add_column :total_costs, :expense_id, :integer, null: true, comment: "経費"
  end
end
