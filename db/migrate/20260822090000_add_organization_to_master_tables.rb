class AddOrganizationToMasterTables < ActiveRecord::Migration[8.1]
  TABLES = %i[institutions expenses expense_work_types land_places owned_rice_prices].freeze

  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    TABLES.each do |table|
      add_reference table, :organization, null: true, foreign_key: true, comment: "組織"
    end

    execute "UPDATE institutions SET organization_id = #{default_org_id}"
    execute "UPDATE expenses SET organization_id = #{default_org_id}"
    execute <<~SQL.squish
      UPDATE expense_work_types
         SET organization_id = expenses.organization_id
        FROM expenses
       WHERE expense_work_types.expense_id = expenses.id
    SQL
    execute "UPDATE expense_work_types SET organization_id = #{default_org_id} WHERE organization_id IS NULL"
    execute "UPDATE land_places SET organization_id = #{default_org_id}"
    execute "UPDATE owned_rice_prices SET organization_id = #{default_org_id}"

    remove_index :owned_rice_prices, name: :owned_rice_prices_2nd
    add_index :owned_rice_prices, [:organization_id, :term, :work_type_id],
              unique: true, name: :owned_rice_prices_2nd
  end

  def down
    remove_index :owned_rice_prices, name: :owned_rice_prices_2nd
    add_index :owned_rice_prices, [:term, :work_type_id], unique: true, name: :owned_rice_prices_2nd

    TABLES.reverse_each do |table|
      remove_reference table, :organization, foreign_key: true
    end
  end
end
