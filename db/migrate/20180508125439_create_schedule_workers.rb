class CreateScheduleWorkers < ActiveRecord::Migration
  def change
    create_table :schedule_workers, {comment: "作業予定作業者"} do |t|
      t.integer :schedule_id,   {comment: "作業予定"}
      t.integer :worker_id,     {comment: "作業者"}
      t.integer :display_order, {null: false, default: 0, comment: "表示順"}

      t.timestamps null: false
    end
    add_index :schedule_workers, [:schedule_id, :worker_id], {unique: true}
  end
end
