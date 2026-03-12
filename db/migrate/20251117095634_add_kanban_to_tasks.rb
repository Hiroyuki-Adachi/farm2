class AddKanbanToTasks < ActiveRecord::Migration[8.1]
  def change
    add_column :tasks, :kanban_position, :integer, default: 0, null: false, comment: 'カンバンの位置'
    add_index :tasks, [:task_status_id, :kanban_position]
  end
end
