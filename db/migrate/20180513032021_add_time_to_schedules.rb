class AddTimeToSchedules < ActiveRecord::Migration[4.2]
  def up
    add_column :schedules, :start_at, :datetime, {null: false, default: "1970-01-01 08:00", comment: "開始予定時刻"}
    add_column :schedules, :end_at, :datetime, {null: false, default: "1970-01-01 17:00", comment: "終了予定時刻"}
  end

  def down
    remove_column :schedules, :start_at
    remove_column :schedules, :end_at
  end
end
