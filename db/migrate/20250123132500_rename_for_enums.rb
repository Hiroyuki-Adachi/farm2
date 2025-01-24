class RenameForEnums < ActiveRecord::Migration[8.0]
  def up
    rename_column :accidents, :accident_type_id, :accident_type
    rename_column :workers, :gender_id, :gender
    rename_column :workers, :position_id, :position
  end

  def down
    rename_column :accidents, :accident_type, :accident_type_id
    rename_column :workers, :gender, :gender_id
    rename_column :workers, :position, :position_id
  end
end
