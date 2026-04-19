class AddOrganizationToCoreTables < ActiveRecord::Migration[8.0]
  def up
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    add_reference :homes, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :workers, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :lands, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_reference :works, :organization, null: false, default: default_org_id, foreign_key: true, comment: "組織"
    add_index :works, [:organization_id, :term]

    execute <<~SQL.squish
      UPDATE workers
         SET organization_id = homes.organization_id
        FROM homes
       WHERE workers.home_id = homes.id
    SQL

    execute <<~SQL.squish
      UPDATE lands
         SET organization_id = homes.organization_id
        FROM homes
       WHERE homes.id = lands.owner_id
    SQL

    execute <<~SQL.squish
      UPDATE lands
         SET organization_id = homes.organization_id
        FROM homes
       WHERE lands.owner_id IS NULL
         AND homes.id = lands.manager_id
    SQL

    execute <<~SQL.squish
      UPDATE works
         SET organization_id = workers.organization_id
        FROM workers
       WHERE works.created_by = workers.id
    SQL
  end

  def down
    remove_index :works, column: [:organization_id, :term]
    remove_reference :works, :organization, foreign_key: true
    remove_reference :lands, :organization, foreign_key: true
    remove_reference :workers, :organization, foreign_key: true
    remove_reference :homes, :organization, foreign_key: true
  end
end
