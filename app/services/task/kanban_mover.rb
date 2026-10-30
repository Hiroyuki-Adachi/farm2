# カンバン上でタスクを移動する。列が変われば状態を変更し、状態変更イベントを記録する。
class Task::KanbanMover < Task::Changer
  def call!(new_kanban_column, new_position)
    Task.transaction do
      old_status_id = @task.task_status_id
      old_kanban_column = TaskStatus.find_by(id: old_status_id)&.kanban_column

      if old_kanban_column == new_kanban_column
        @task.update!(kanban_position: new_position)
      else
        new_status = TaskStatus.kanban_status(old_status_id, new_kanban_column)
        @task.kanban_position = new_position
        assign_status(new_status, :completed)
        @task.save!
        TaskEvent.create!(
          task_id: @task.id,
          actor_id: @actor.id,
          event_type: :change_status,
          status_from_id: old_status_id,
          status_to_id: new_status.id,
          source: :kanban
        )
      end
    end
    @task
  end
end
