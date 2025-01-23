class RemoveAccountFromWorkers < ActiveRecord::Migration[8.0]
  def up
    remove_column :workers, :bank_code
    remove_column :workers, :branch_code
    remove_column :workers, :account_type_id
    remove_column :workers, :account_number

    remove_column :organizations, :bank_code
    remove_column :organizations, :branch_code
    remove_column :organizations, :account_type_id
    remove_column :organizations, :account_number
  end

  def down
    add_column :workers, :bank_code, :string, null: false, default: '0000'
    add_column :workers, :branch_code, :string, null: false, default: '000'
    add_column :workers, :account_type_id, :integer, null: false, default: 0
    add_column :workers, :account_number, :string, null: false, default: '0000000'

    add_column :organizations, :bank_code, :string, null: false, default: '0000'
    add_column :organizations, :branch_code, :string, null: false, default: '000'
    add_column :organizations, :account_type_id, :integer, null: false, default: 0
    add_column :organizations, :account_number, :string, null: false, default: '0000000'
  end
end
