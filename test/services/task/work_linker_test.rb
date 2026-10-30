require "test_helper"

class Task::WorkLinkerTest < ActiveSupport::TestCase
  test "作業追加(ステータスが対応中)" do
    task = tasks(:started_task)
    worker = workers(:worker1)
    work = works(:works1)

    assert_difference("TaskEvent.count", 1) do
      Task::WorkLinker.new(task, actor: worker).link!(work: work)
    end

    created_event = TaskEvent.last
    assert_equal worker.id, created_event.actor_id
    assert_equal task.id, created_event.task_id
    assert created_event.add_work?
    assert_equal work.id, created_event.work_id
    assert_nil created_event.status_from_id
    assert_nil created_event.status_to_id
  end

  test "作業追加(ステータスが未着手)" do
    task = tasks(:open_task)
    worker = workers(:worker1)
    work = works(:works1)
    comment = "作業を開始します"

    assert_difference("TaskComment.count", 1) do
      assert_difference("TaskEvent.count", 1) do
        Task::WorkLinker.new(task, actor: worker).link!(work: work, comment: comment)
      end
    end

    task_comment = TaskComment.last
    assert_equal comment, task_comment.body
    assert_equal worker.id, task_comment.poster_id
    assert_equal task.id, task_comment.task_id

    created_event = TaskEvent.last
    assert_equal worker.id, created_event.actor_id
    assert_equal task.id, created_event.task_id
    assert created_event.change_status?
    assert_equal work.id, created_event.work_id
    assert_equal task_comment, created_event.comment
    assert_equal TaskStatus::TO_DO.id, created_event.status_from_id
    assert_equal TaskStatus::DOING.id, created_event.status_to_id

    task.reload
    assert_equal TaskStatus::DOING.id, task.task_status_id
    assert_equal work.worked_at, task.started_on
  end

  test "作業追加(完了モード)" do
    task = tasks(:open_task)
    worker = workers(:worker1)
    work = works(:works1)

    assert_difference("TaskEvent.count", 1) do
      Task::WorkLinker.new(task, actor: worker).link!(work: work, close: true)
    end

    created_event = TaskEvent.last
    assert_equal worker.id, created_event.actor_id
    assert_equal task.id, created_event.task_id
    assert created_event.change_status?
    assert_equal work.id, created_event.work_id
    assert_equal TaskStatus::TO_DO.id, created_event.status_from_id
    assert_equal TaskStatus::DONE.id, created_event.status_to_id

    task.reload
    assert_equal TaskStatus::DONE.id, task.task_status_id
    assert_equal work.worked_at, task.started_on
    assert_equal work.worked_at, task.ended_on
    assert_equal :completed, task.end_reason.to_sym
  end

  test "作業削除(関連作業がない)" do
    task = tasks(:open_task)
    work = works(:works1)
    original_status = task.task_status_id

    assert_no_difference("TaskEvent.count") do
      assert_nil Task::WorkLinker.new(task).unlink!(work: work)
    end

    task.reload
    assert_equal original_status, task.task_status_id
  end

  test "作業削除(関連作業が存在かつ作業追加イベント)" do
    task = tasks(:work_task)
    event = task.events.last
    work = event.work
    original_status = task.task_status_id

    event.update!(event_type: :add_work, status_from_id: nil, status_to_id: nil)

    assert_difference("TaskEvent.count", -1) do
      Task::WorkLinker.new(task).unlink!(work: work)
    end

    task.reload
    assert_equal original_status, task.task_status_id
  end

  test "作業削除(関連作業が存在かつステータス変更イベントが最後)" do
    task = tasks(:work_task)
    event = task.events.last
    work = event.work

    event.update!(event_type: :change_status, status_from_id: TaskStatus::TO_DO.id, status_to_id: TaskStatus::DOING.id)

    assert_difference("TaskEvent.count", -1) do
      Task::WorkLinker.new(task).unlink!(work: work)
    end

    task.reload
    assert_equal TaskStatus::TO_DO.id, task.task_status_id
  end

  test "日報への一括紐づけは選択したタスクを紐づけ、紐づけ済みのタスクは飛ばす" do
    worker = workers(:worker1)
    work = works(:works1)
    started_task = tasks(:started_task)
    open_task = tasks(:open_task)
    Task::WorkLinker.new(started_task, actor: worker).link!(work: work)

    assert_difference("TaskEvent.count", 1) do
      Task::WorkLinker.link_all!(
        actor: worker, work: work,
        check_task_ids: [started_task.id, open_task.id], close_task_ids: [open_task.id.to_s]
      )
    end

    assert_equal 1, started_task.events.where(work_id: work.id).count
    assert_equal TaskStatus::DONE, open_task.reload.status
  end
end
