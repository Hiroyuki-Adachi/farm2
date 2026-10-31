require "test_helper"

class Task::DueOnChangerTest < ActiveSupport::TestCase
  test "期限変更" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    new_due = Date.current + 7.days
    comment = "期限を合わせます"

    assert_changes -> { open_task.reload.due_on }, to: new_due do
      Task::DueOnChanger.new(open_task, actor: worker1).call!(new_due, comment: comment)
    end

    last_event = open_task.events.order(:id).last
    assert_equal :change_due_on, last_event.event_type.to_sym
    assert_equal new_due, last_event.due_on_to
    assert_equal comment, last_event.comment&.body
  end

  test "期限変更(同じ期限)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    open_task.update!(due_on: nil)

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::DueOnChanger.new(open_task, actor: worker1).call!(nil)
    end
    assert open_task.errors.any?
  end

  test "期限変更(完了済)" do
    worker1 = workers(:worker1)
    closed_task = tasks(:closed_task)
    closed_task.update!(due_on: Time.zone.yesterday)

    assert_raises(ActiveRecord::RecordInvalid) do
      Task::DueOnChanger.new(closed_task, actor: worker1).call!(Time.zone.today)
    end
    assert closed_task.errors.any?
  end
end
