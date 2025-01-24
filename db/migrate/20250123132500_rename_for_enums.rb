class RenameForEnums < ActiveRecord::Migration[8.0]
  def up
    rename_column :accidents, :accident_type_id, :accident_type
  end

  def down
    rename_column :accidents, :accident_type, :accident_type_id
  end
end
