class AddLandToWorkKinds < ActiveRecord::Migration[4.2]
  def up
    add_column :work_kinds, :land_flag, :boolean, {null: false, default: true, comment: "土地利用フラグ"}
  end

  def down
    remove_column :work_kinds, :land_flag
  end
end
