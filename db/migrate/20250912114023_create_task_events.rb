class CreateTaskEvents < ActiveRecord::Migration[8.0]
  def change
    create_table :task_events, comment: "タスクイベント" do |t|
      t.references :task,  null: false, foreign_key: true, comment: '対象タスク'
      t.references :actor, null: false, foreign_key: { to_table: :workers }, comment: '実行者'
      t.integer :event_type, null: false, comment: 'イベント種別'
      t.integer :status_from_id, null: true, comment: '変更前ステータス'
      t.integer :status_to_id, null: true, comment: '変更後ステータス'
      t.references :assignee_from, null: true, foreign_key: { to_table: :workers }, comment: '変更前の担当者'
      t.references :assignee_to, null: true, foreign_key: { to_table: :workers }, comment: '変更後の担当者'
      t.date :due_on_from, null: true, comment: '変更前の期限'
      t.date :due_on_to, null: true, comment: '変更後の期限'
      t.references :task_comment, null: true, foreign_key: true, comment: '関連コメント'

      t.timestamps
    end
    add_index :task_events, [:task_id, :created_at] 
  end
end
