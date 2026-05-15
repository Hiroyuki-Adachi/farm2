class AddOrganizationToChemicalTables < ActiveRecord::Migration[8.1]
  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    add_reference :chemicals, :organization, null: true, foreign_key: true, comment: "組織"
    add_reference :chemical_terms, :organization, null: true, foreign_key: true, comment: "組織"
    add_reference :chemical_inventories, :organization, null: true, foreign_key: true, comment: "組織"
    add_reference :chemical_stocks, :organization, null: true, foreign_key: true, comment: "組織"

    execute "UPDATE chemicals SET organization_id = #{default_org_id}"
    execute "UPDATE chemical_inventories SET organization_id = #{default_org_id}"

    execute <<~SQL.squish
      UPDATE chemical_terms
         SET organization_id = chemicals.organization_id
        FROM chemicals
       WHERE chemical_terms.chemical_id = chemicals.id
    SQL

    execute <<~SQL.squish
      UPDATE chemical_stocks
         SET organization_id = chemicals.organization_id
        FROM chemicals
       WHERE chemical_stocks.chemical_id = chemicals.id
    SQL

    execute <<~SQL.squish
      UPDATE chemical_stocks
         SET organization_id = chemical_inventories.organization_id
        FROM chemical_inventories
       WHERE chemical_stocks.chemical_inventory_id = chemical_inventories.id
    SQL

    execute <<~SQL.squish
      UPDATE chemical_stocks
         SET organization_id = works.organization_id
        FROM work_chemicals
        INNER JOIN works ON works.id = work_chemicals.work_id
       WHERE chemical_stocks.work_chemical_id = work_chemicals.id
    SQL

    remove_index :chemical_terms, column: [:chemical_id, :term]
    add_index :chemical_terms, [:organization_id, :chemical_id, :term], unique: true
    add_index :chemical_stocks, [:organization_id, :chemical_id, :stock_on]
    add_index :chemical_inventories, [:organization_id, :checked_on]

    change_column_null :chemicals, :organization_id, false
    change_column_null :chemical_terms, :organization_id, false
    change_column_null :chemical_inventories, :organization_id, false
    change_column_null :chemical_stocks, :organization_id, false
  end

  def down
    change_column_null :chemical_stocks, :organization_id, true
    change_column_null :chemical_inventories, :organization_id, true
    change_column_null :chemical_terms, :organization_id, true
    change_column_null :chemicals, :organization_id, true

    remove_index :chemical_inventories, column: [:organization_id, :checked_on]
    remove_index :chemical_stocks, column: [:organization_id, :chemical_id, :stock_on]
    remove_index :chemical_terms, column: [:organization_id, :chemical_id, :term]
    add_index :chemical_terms, [:chemical_id, :term], unique: true

    remove_reference :chemical_stocks, :organization, foreign_key: true
    remove_reference :chemical_inventories, :organization, foreign_key: true
    remove_reference :chemical_terms, :organization, foreign_key: true
    remove_reference :chemicals, :organization, foreign_key: true
  end
end
