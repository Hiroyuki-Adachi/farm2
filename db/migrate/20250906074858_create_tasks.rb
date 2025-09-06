class CreateTasks < ActiveRecord::Migration[8.0]
  def change
    create_table :tasks, comment: 'タスク' do |t|
      t.string  :title, null: false, limit: 64, comment: 'タスク名'
      t.text   :description, null: false, comment: '説明'
      t.integer :status, null: false, default: 0, comment: '状態'
      t.integer :priority, null: false, default: 0, comment: '優先度'
      t.date :due_on, null: true, comment: '期限'
      t.date :started_on, null: true, comment: '着手日'
      t.date :ended_on, null: true, comment: '完了日'
      t.integer :end_reason, null: false, default: 0, comment: '完了理由'
      t.integer :office_role, null: false, default: 0, comment: '役割'

      t.references :assignee, null: true, foreign_key: { to_table: :workers }, comment: '担当者'
      t.references :creator, null: false, foreign_key: { to_table: :workers }, comment: '作成者'
      
      t.timestamps
    end
  end
end
