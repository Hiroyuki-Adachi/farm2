class CreateTaskReads < ActiveRecord::Migration[8.0]
  def change
    create_table :task_reads, comment: "タスク既読" do |t|
      t.references :task, null: false, foreign_key: true, comment: "タスクID"
      t.references :worker, null: false, foreign_key: true, comment: "作業者ID"
      t.datetime :last_read_at, null: false, default: -> { "TIMESTAMP '1970-01-01 00:00:00'" }, comment: "最終既読日時"

      t.timestamps
    end
    add_index :task_reads, [:task_id, :worker_id], unique: true

    add_index :task_comments, [:task_id, :updated_at]
    add_index :task_comments, [:task_id, :poster_id, :updated_at]

    add_index :task_events,   [:task_id, :updated_at]
    add_index :task_events,   [:task_id, :actor_id,  :updated_at]
  end
end
