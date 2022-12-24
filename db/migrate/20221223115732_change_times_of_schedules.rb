class ChangeTimesOfSchedules < ActiveRecord::Migration[7.0]
  def up
    change_column :schedules, :start_at, :time
    change_column :schedules, :end_at, :time
  end

  def down
    work_starts = Work.all.map{|d| [d.id, d.start_at.strftime('%H:%M')]}.to_h
    work_ends = Work.all.map{|d| [d.id, d.end_at.strftime('%H:%M')]}.to_h

    remove_column :schedules, :start_at
    remove_column :schedules, :end_at

    add_column :schedules, :start_at, :datetime, null: true, comment: "開始時刻"
    add_column :schedules, :end_at, :datetime, null: true, comment: "終了時刻"

    Schedule.all.each do |w|
      w.update(
        start_at: "2000-01-01 #{work_starts[w.id]}:00",
        end_at: "2000-01-01 #{work_ends[w.id]}:00"
      )
    end

    change_column :schedules, :start_at, null: false
    change_column :schedules, :end_at, null: false
  end
end
