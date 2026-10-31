require "test_helper"

class Task::KanbanMoverTest < ActiveSupport::TestCase
  test "カンバン移動(位置のみを変更した場合)" do
    worker = workers(:worker1)
    task = Task.create!(
      title: "テストタスク",
      description: "same column move",
      task_status_id: TaskStatus::TO_DO.id,
      assignee_id: worker.id,
      kanban_position: 0
    )

    assert_no_difference "TaskEvent.count" do
      Task::KanbanMover.new(task, actor: worker).call!(TaskStatus::TO_DO.kanban_column, 3)
    end

    task.reload
    assert_equal 3, task.kanban_position
    assert_equal TaskStatus::TO_DO.id, task.task_status_id
  end

  test "カンバン移動(ステータスも変更した場合)" do
    worker = workers(:worker1)
    task = Task.create!(
      title: "ステータス変更タスク",
      description: "move to doing column",
      task_status_id: TaskStatus::TO_DO.id,
      assignee_id: worker.id,
      kanban_position: 0
    )

    new_status_id = TaskStatus::DOING.id

    assert_difference "TaskEvent.count", +1 do
      Task::KanbanMover.new(task, actor: worker).call!(TaskStatus::DOING.kanban_column, 1)
    end

    task.reload
    assert_equal new_status_id, task.task_status_id
    assert_equal 1, task.kanban_position

    event = TaskEvent.order(:id).last
    assert_equal task.id, event.task_id
    assert_equal worker.id, event.actor_id
    assert_equal :change_status, event.event_type.to_sym
    assert_equal TaskStatus::TO_DO.id, event.status_from_id
    assert_equal new_status_id, event.status_to_id
    assert_equal :kanban, event.source.to_sym
  end
end
