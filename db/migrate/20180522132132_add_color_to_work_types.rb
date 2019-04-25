class AddColorToWorkTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :work_types, :bg_color, :string, {limit: 8, null: true, comment: "背景色"}
    add_column :work_types, :land_flag, :boolean, {null: false, default: true, comment: "土地利用"}
  end
end
