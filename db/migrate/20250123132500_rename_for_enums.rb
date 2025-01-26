class RenameForEnums < ActiveRecord::Migration[8.0]
  def up
    rename_column :accidents, :accident_type_id, :accident_type
    rename_column :workers, :gender_id, :gender
    rename_column :workers, :position_id, :position
    rename_column :works, :weather_id, :weather
    rename_column :chemical_inventories, :chemical_adjust_type_id, :chemical_adjust_type
    rename_column :users, :permission_id, :permission
    rename_column :dryings, :drying_type_id, :drying_type
    rename_column :machine_price_details, :lease_id, :lease
    rename_column :machine_price_details, :adjust_id, :adjust
    rename_column :machine_results, :fixed_adjust_id, :fixed_adjust
  end

  def down
    rename_column :accidents, :accident_type, :accident_type_id
    rename_column :workers, :gender, :gender_id
    rename_column :workers, :position, :position_id
    rename_column :works, :weather, :weather_id
    rename_column :chemical_inventories, :chemical_adjust_type, :chemical_adjust_type_id
    rename_column :users, :permission, :permission_id
    rename_column :dryings, :drying_type, :drying_type_id
    rename_column :machine_price_details, :lease, :lease_id
    rename_column :machine_price_details, :adjust, :adjust_id
    rename_column :machine_results, :fixed_adjust, :fixed_adjust_id
  end
end
