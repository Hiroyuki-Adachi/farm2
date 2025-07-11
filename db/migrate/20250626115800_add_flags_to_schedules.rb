class AddFlagsToSchedules < ActiveRecord::Migration[8.0]
  def change
    add_column :schedules, :minutes_flag, :boolean, null: false, default: true, comment: "議事録フラグ"
    add_column :schedules, :line_flag, :boolean, null: false, default: true, comment: "LINEフラグ"
    add_column :schedules, :calendar_remove_flag, :boolean, null: false, default: false, comment: "カレンダー削除フラグ"
    add_column :schedules, :farming_flag, :boolean, null: false, default: true, comment: "営農フラグ"
    add_column :schedules, :created_by, :integer, null: false, default: 0, comment: "作成者ID"
  end
end
