class AddOrganizationToMasterTables < ActiveRecord::Migration[8.1]
  def up
    # Add organization_id to sections (班／町内マスタ)
    add_column :sections, :organization_id, :integer, null: true, comment: "組織"
    Section.update_all(organization_id: Organization.first&.id)
    change_column_null :sections, :organization_id, false
    change_column_default :sections, :organization_id, 0
    add_index :sections, :organization_id

    # Add organization_id to homes (世帯マスタ)
    add_column :homes, :organization_id, :integer, null: true, comment: "組織"
    Home.update_all(organization_id: Organization.first&.id)
    change_column_null :homes, :organization_id, false
    change_column_default :homes, :organization_id, 0
    add_index :homes, :organization_id

    # Add organization_id to workers (作業者マスタ)
    add_column :workers, :organization_id, :integer, null: true, comment: "組織"
    Worker.update_all(organization_id: Organization.first&.id)
    change_column_null :workers, :organization_id, false
    change_column_default :workers, :organization_id, 0
    add_index :workers, :organization_id

    # Add organization_id to lands (土地マスタ)
    add_column :lands, :organization_id, :integer, null: true, comment: "組織"
    Land.update_all(organization_id: Organization.first&.id)
    change_column_null :lands, :organization_id, false
    change_column_default :lands, :organization_id, 0
    add_index :lands, :organization_id

    # Add organization_id to machines (機械マスタ)
    add_column :machines, :organization_id, :integer, null: true, comment: "組織"
    Machine.update_all(organization_id: Organization.first&.id)
    change_column_null :machines, :organization_id, false
    change_column_default :machines, :organization_id, 0
    add_index :machines, :organization_id
  end

  def down
    remove_index :sections, :organization_id
    remove_column :sections, :organization_id

    remove_index :homes, :organization_id
    remove_column :homes, :organization_id

    remove_index :workers, :organization_id
    remove_column :workers, :organization_id

    remove_index :lands, :organization_id
    remove_column :lands, :organization_id

    remove_index :machines, :organization_id
    remove_column :machines, :organization_id
  end
end
