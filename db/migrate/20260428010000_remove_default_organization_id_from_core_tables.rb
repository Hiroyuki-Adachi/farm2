class RemoveDefaultOrganizationIdFromCoreTables < ActiveRecord::Migration[8.1]
  def up
    change_column_default :homes, :organization_id, nil
    change_column_default :workers, :organization_id, nil
    change_column_default :lands, :organization_id, nil
    change_column_default :works, :organization_id, nil
  end

  def down
    default_org_id = select_value("SELECT id FROM organizations ORDER BY id LIMIT 1").to_i
    raise ActiveRecord::IrreversibleMigration, "organizations is empty" if default_org_id.zero?

    change_column_default :homes, :organization_id, default_org_id
    change_column_default :workers, :organization_id, default_org_id
    change_column_default :lands, :organization_id, default_org_id
    change_column_default :works, :organization_id, default_org_id
  end
end
