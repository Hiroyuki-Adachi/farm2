class ChangeHoursScaleOnMachineResults < ActiveRecord::Migration[8.1]
  def up
    change_column :machine_results, :hours, :decimal,
                  precision: 4, scale: 2, default: "0.0", null: false, comment: "稼動時間"
  end

  def down
    change_column :machine_results, :hours, :decimal,
                  precision: 3, scale: 1, default: "0.0", null: false, comment: "稼動時間"
  end
end
