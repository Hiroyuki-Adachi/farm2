class AddIconToWorkTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :work_types, :icon_name, :string, {limit: 40, null: true, comment: "アイコン名"}
    add_column :work_types, :icon, :binary, {limit: 1.megabyte, null: true, comment: "アイコン"}
  end
end
