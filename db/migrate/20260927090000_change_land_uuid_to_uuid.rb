class ChangeLandUuidToUuid < ActiveRecord::Migration[8.1]
  def up
    remove_index :lands, name: "index_lands_on_uuid"
    change_column_default :lands, :uuid, nil
    change_column :lands, :uuid, :uuid, using: "uuid::uuid"
    add_index :lands, :uuid, unique: true, where: "uuid IS NOT NULL"
  end

  def down
    remove_index :lands, name: "index_lands_on_uuid"
    change_column :lands, :uuid, :string, limit: 36, using: "uuid::text"
    change_column_default :lands, :uuid, ""
    add_index :lands, :uuid, unique: true, where: "uuid <> ''"
  end
end
