class ChangeTimesOfWorks < ActiveRecord::Migration[7.0]
  def up
    change_column :works, :start_at, :time
    change_column :works, :end_at, :time
  end

  def down
    remove_column :works, :start_at
    remove_column :works, :end_at

    add_column :works, :start_at, :datetime, null: true, comment: "開始時刻"
    add_column :works, :end_at, :datetime, null: true, comment: "終了時刻"
  end
end
