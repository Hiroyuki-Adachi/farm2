class CreateTaskComments < ActiveRecord::Migration[8.0]
  def change
    create_table :task_comments, comment: "タスクコメント" do |t|
      t.references :task, null: false, foreign_key: true, comment: '対象タスク'
      t.references :poster, null: false, foreign_key: { to_table: :workers }, comment: '投稿者'
      t.text :body, null: false, default: '', comment: 'コメント本文'

      t.timestamps
    end

    add_index :task_comments, [:task_id, :created_at] 
  end
end
