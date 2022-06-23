class ChangeTimesOfWorks < ActiveRecord::Migration[7.0]
  def up
    change_column :works, :start_at, :time
    change_column :works, :end_at, :time
  end

  def down
    work_starts = Work.all.map{|d| [d.id, d.start_at.strftime('%H:%M')]}.to_h
    work_ends = Work.all.map{|d| [d.id, d.end_at.strftime('%H:%M')]}.to_h

    remove_column :works, :start_at
    remove_column :works, :end_at

    add_column :works, :start_at, :datetime, null: true, comment: "開始時刻"
    add_column :works, :end_at, :datetime, null: true, comment: "終了時刻"

    Work.all.each do |w|
      w.update(
        start_at: "2000-01-01 #{work_starts[w.id]}:00",
        end_at: "2000-01-01 #{work_ends[w.id]}:00"
      )
    end

    change_column :works, :start_at, null: false
    change_column :works, :end_at, null: false
  end
end
