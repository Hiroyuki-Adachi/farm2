class AddSourceToTaskEvents < ActiveRecord::Migration[8.1]
  def change
    add_column :task_events, :source, :integer, default: 0, null: false, comment: 'ソース'
  end
end
