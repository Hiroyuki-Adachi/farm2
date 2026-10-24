require "test_helper"

class Task::StatusChangerTest < ActiveSupport::TestCase
  test "ステータス変更(未着手⇒進行中)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    comment = "開始します"
    params = { task_status: :doing, comment: comment }

    assert_changes -> { open_task.reload.task_status_id }, to: TaskStatus::DOING.id do
      Task::StatusChanger.new(open_task, actor: worker1).call!(**params)
    end
    assert_equal Date.current, open_task.started_on
    assert_equal Date.current, open_task.planned_start_on

    last_event = open_task.events.order(:id).last
    assert_equal :change_status, last_event.event_type.to_sym
    assert_equal TaskStatus::TO_DO.id, last_event.status_from_id
    assert_equal TaskStatus::DOING.id, last_event.status_to_id
    assert_equal comment, last_event.comment&.body
  end

  test "ステータス変更(進行中⇒完了)" do
    worker1 = workers(:worker1)
    started_task = tasks(:started_task)
    comment = "完了します"
    params = { task_status: :done, end_reason: :completed, comment: comment }

    assert_changes -> { started_task.reload.task_status_id }, to: TaskStatus::DONE.id do
      Task::StatusChanger.new(started_task, actor: worker1).call!(**params)
    end

    # 完了固有の値を検証
    assert_equal Date.current, started_task.ended_on
    assert_equal :completed, started_task.end_reason.to_sym
  end

  test "ステータス変更(不正な値)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    params = { task_status: "unknown" }

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::StatusChanger.new(open_task, actor: worker1).call!(**params)
    end
    assert open_task.errors.any?
  end

  test "ステータス変更(同じ値)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    params = { task_status: :to_do }

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::StatusChanger.new(open_task, actor: worker1).call!(**params)
    end
    assert open_task.errors.any?
  end

  test "ステータス変更(禁止ルール抵触)" do
    worker1 = workers(:worker1)

    # OK例（to_do -> cancel）
    task1 = tasks(:open_task)
    assert_changes -> { task1.reload.task_status_id }, to: TaskStatus::CANCEL.id do
      Task::StatusChanger.new(task1, actor: worker1).call!(task_status: :cancel, comment: "中止します")
    end

    # NG例（hold -> to_do）
    task2 = tasks(:open_task)
    task2.update!(task_status_id: TaskStatus::HOLD.id)
    assert_raises(ActiveRecord::RecordInvalid) do
      Task::StatusChanger.new(task2, actor: worker1).call!(task_status: :to_do)
    end
    assert task2.errors.any?
  end
end
