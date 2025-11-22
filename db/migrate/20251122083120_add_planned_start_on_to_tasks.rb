class AddPlannedStartOnToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :planned_start_on, :date, null: false, default: '1900-01-01', comment: "開始予定日"
    Task.reset_column_information
    Task.update_all("planned_start_on = DATE(created_at)")
  end
end
