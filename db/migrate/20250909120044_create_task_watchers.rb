class CreateTaskWatchers < ActiveRecord::Migration[8.0]
  def change
    create_table :task_watchers, comment: 'タスク閲覧者' do |t|
      t.references :task, null: false, foreign_key: { to_table: :tasks }, comment: 'タスクID'
      t.references :worker, null: false, foreign_key: { to_table: :workers }, comment: '閲覧者ID'

      t.timestamps
    end
    add_index :task_watchers, [:worker_id, :task_id], unique: true
  end
end
