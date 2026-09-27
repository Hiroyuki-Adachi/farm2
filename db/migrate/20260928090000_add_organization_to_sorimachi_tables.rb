class AddOrganizationToSorimachiTables < ActiveRecord::Migration[8.1]
  TABLES = %i[sorimachi_accounts sorimachi_journals].freeze

  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    TABLES.each do |table|
      add_reference table, :organization, null: true, index: false, foreign_key: true, comment: "組織"
      execute "UPDATE #{table} SET organization_id = #{default_org_id}"
    end

    remove_index :sorimachi_accounts, name: :sorimachi_accounts_2nd
    add_index :sorimachi_accounts, [:organization_id, :term, :code], unique: true, name: :sorimachi_accounts_2nd

    remove_index :sorimachi_journals, name: :sorimachi_journals_2nd
    add_index :sorimachi_journals, [:organization_id, :term, :line, :detail],
              unique: true, name: :sorimachi_journals_2nd

    remove_index :sorimachi_journals, name: :index_sorimachi_journals_on_term_and_allocation_mode
    add_index :sorimachi_journals, [:organization_id, :term, :allocation_mode], name: :sorimachi_journals_3rd
  end

  def down
    remove_index :sorimachi_journals, name: :sorimachi_journals_3rd
    add_index :sorimachi_journals, [:term, :allocation_mode],
              name: :index_sorimachi_journals_on_term_and_allocation_mode

    remove_index :sorimachi_journals, name: :sorimachi_journals_2nd
    add_index :sorimachi_journals, [:term, :line, :detail], unique: true, name: :sorimachi_journals_2nd

    remove_index :sorimachi_accounts, name: :sorimachi_accounts_2nd
    add_index :sorimachi_accounts, [:term, :code], unique: true, name: :sorimachi_accounts_2nd

    TABLES.reverse_each do |table|
      remove_reference table, :organization, index: false, foreign_key: true
    end
  end
end
