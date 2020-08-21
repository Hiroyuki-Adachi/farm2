class AddIconToWorkTypes < ActiveRecord::Migration[6.0]
  def change
    add_column :work_types, :icon, :binary, {limit: 1.megabyte, null: true, comment: "アイコン"}
  end
end
