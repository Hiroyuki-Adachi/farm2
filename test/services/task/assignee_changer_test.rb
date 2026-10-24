require "test_helper"

class Task::AssigneeChangerTest < ActiveSupport::TestCase
  test "担当者変更処理" do
    worker1 = workers(:worker1)
    worker2 = workers(:worker2)
    open_task = tasks(:open_task)
    comment = "引き継ぎます"

    assert_difference("TaskRead.count", 1) do
      assert_changes -> { open_task.reload.assignee_id }, to: worker2.id do
        Task::AssigneeChanger.new(open_task, actor: worker1).call!(worker2.id, comment: comment)
      end
    end

    last_event = open_task.events.order(:id).last
    assert_equal :change_assignee, last_event.event_type.to_sym
    assert_equal worker1.id, last_event.assignee_from_id
    assert_equal worker2.id, last_event.assignee_to_id
    assert_equal comment, last_event.comment&.body

    assert open_task.task_watchers.exists?(worker_id: worker2.id)

    last_read = open_task.reads.find_by(worker_id: worker2.id)
    assert_not_nil last_read
    assert_equal Time.at(0).to_i, last_read.last_read_at.to_i
  end

  test "担当者変更処理(同じ担当者)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::AssigneeChanger.new(open_task, actor: worker1).call!(worker1.id, comment: "同じ人です")
    end
    assert open_task.errors.any?
  end

  test "担当者変更処理(完了済)" do
    worker2 = workers(:worker2)
    closed_task = tasks(:closed_task)

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::AssigneeChanger.new(closed_task, actor: worker2).call!(worker2.id, comment: "完了済です")
    end
    assert closed_task.errors.any?
  end
end
