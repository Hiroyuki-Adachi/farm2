class SetDefaultOrganizationIdOnCoreTables < ActiveRecord::Migration[8.1]
  def up
    change_column_default :homes, :organization_id, 1
    change_column_default :workers, :organization_id, 1
    change_column_default :lands, :organization_id, 1
    change_column_default :works, :organization_id, 1
  end

  def down
    change_column_default :homes, :organization_id, nil
    change_column_default :workers, :organization_id, nil
    change_column_default :lands, :organization_id, nil
    change_column_default :works, :organization_id, nil
  end
end
