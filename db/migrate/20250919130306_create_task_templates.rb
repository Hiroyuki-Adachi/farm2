class CreateTaskTemplates < ActiveRecord::Migration[8.0]
  def change
    create_table :task_templates, comment: '定型タスク' do |t|
      t.integer :kind, null: false, default: 0, comment: '年次/月次'
      t.string  :title, null: false, limit: 40, comment: 'タスク名'
      t.text    :description, null: false, default: "", comment: '説明'
      t.integer :priority, null: false, default: 0, comment: '優先度'
      t.integer :office_role, null: false, default: 0, comment: '役割'
      t.integer :monthly_stage, null: false, default: 0, comment: '期日週'
      t.integer :annual_month, null: true, comment: '期日月'
      t.integer :months_before_due, null: false, default: 1, comment: '事前通知月数'
      t.integer :year_offset, null: false, default: 0, comment: '基準年からのズレ'
      t.boolean :active, null: false, default: true, comment: '有効'
      t.datetime :discarded_at, null: true, comment: '論理削除日時'

      t.timestamps
    end
    add_index :task_templates, [:kind, :annual_month, :monthly_stage]

    change_table :tasks do |t|
      t.references :task_template, foreign_key: true, null: true, comment: '定型タスクID'
    end
  end
end
