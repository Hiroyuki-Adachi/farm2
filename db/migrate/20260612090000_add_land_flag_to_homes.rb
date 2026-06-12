class AddLandFlagToHomes < ActiveRecord::Migration[8.1]
  def change
    add_column :homes, :land_flag, :boolean, null: false, default: true, comment: "土地フラグ"
  end
end
