class AddCostFlagToWorkTypes < ActiveRecord::Migration[6.1]
  def change
    add_column :work_types, :cost_flag, :boolean,  {null: false, default: false, comment: "原価フラグ"}
    WorkType.where(land_flag: true).update(cost_flag: true)
  end
end
