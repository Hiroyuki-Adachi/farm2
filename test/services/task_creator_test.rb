require "test_helper"

class TaskCreatorTest < ActiveSupport::TestCase
  setup do
    @creator = workers(:worker1)
    @assignee = workers(:worker2)
  end

  test "作成者ありでは閲覧者・作成イベント・既読を作成する" do
    task = nil
    travel_to Time.zone.local(2026, 4, 10, 9, 0, 0) do
      task = build_task(creator: @creator, assignee: @assignee)
      assert TaskCreator.new(task).call
    end

    assert task.persisted?
    assert_equal [@creator.id, @assignee.id].sort, task.task_watchers.pluck(:worker_id).sort
    event = task.events.sole
    assert_equal "task_created", event.event_type
    assert_equal @creator.id, event.actor_id
    assert_equal "form", event.source
    assert_equal task.created_at, task.reads.find_by!(worker_id: @creator.id).last_read_at
    assert_equal Time.zone.at(0), task.reads.find_by!(worker_id: @assignee.id).last_read_at
  end

  test "作成者と担当者が同じ場合は閲覧者と既読を1件ずつ作成する" do
    task = TaskCreator.new(build_task(creator: @creator, assignee: @creator)).call!

    assert_equal [@creator.id], task.task_watchers.pluck(:worker_id)
    assert_equal [@creator.id], task.reads.pluck(:worker_id)
  end

  test "作成者なしでは作成イベントと既読を作成しない" do
    task = TaskCreator.new(build_task(creator: nil, assignee: @assignee)).call!

    assert_equal [@assignee.id], task.task_watchers.pluck(:worker_id)
    assert_empty task.events
    assert_empty task.reads
  end

  test "開始予定日は入力値によらず作成日を設定する" do
    travel_to Time.zone.local(2026, 4, 10, 23, 59, 0) do
      task = TaskCreator.new(build_task(creator: @creator, planned_start_on: Date.new(2026, 1, 1))).call!

      assert_equal Date.new(2026, 4, 10), task.planned_start_on
      assert_equal task.created_at.to_date, task.reload.planned_start_on
    end
  end

  test "完了状態で作成日より前の完了日がある場合は開始予定日を完了日に合わせる" do
    travel_to Time.zone.local(2026, 4, 10, 9, 0, 0) do
      task = build_task(creator: @creator, task_status_id: TaskStatus::DONE.id,
                        started_on: Date.new(2026, 4, 1), ended_on: Date.new(2026, 4, 5), end_reason: :completed)

      assert TaskCreator.new(task).call
      assert_equal Date.new(2026, 4, 5), task.reload.planned_start_on
    end
  end

  test "作成時にタスクへのUPDATEを発行しない" do
    statements = capture_sql { TaskCreator.new(build_task(creator: @creator, assignee: @assignee)).call! }

    assert_equal(1, statements.count { |sql| sql.start_with?('INSERT INTO "tasks"') })
    assert_empty(statements.select { |sql| sql.start_with?('UPDATE "tasks"') })
  end

  test "保存できない場合はfalseを返し関連を作成しない" do
    task = build_task(creator: @creator, assignee: @assignee, title: "")

    assert_no_difference(["Task.count", "TaskWatcher.count", "TaskEvent.count", "TaskRead.count"]) do
      assert_not TaskCreator.new(task).call
    end
    assert task.errors.key?(:title)
  end

  test "call!は保存できない場合に例外を出す" do
    assert_raises(ActiveRecord::RecordInvalid) do
      TaskCreator.new(build_task(creator: @creator, title: "")).call!
    end
  end

  test "関連の作成に失敗した場合はタスクも作成しない" do
    TaskEvent.stubs(:create!).raises(ActiveRecord::RecordInvalid)

    assert_no_difference(["Task.count", "TaskWatcher.count", "TaskRead.count"]) do
      assert_raises(ActiveRecord::RecordInvalid) do
        TaskCreator.new(build_task(creator: @creator, assignee: @assignee)).call
      end
    end
  end

  private

  def build_task(creator:, assignee: nil, **attributes)
    Task.new(
      organization_id: @creator.organization_id,
      title: "作成テスト",
      task_status_id: TaskStatus::TO_DO.id,
      priority: :low,
      creator: creator,
      assignee: assignee,
      **attributes
    )
  end

  def capture_sql(&)
    statements = []
    callback = ->(*, payload) { statements << payload[:sql] unless payload[:name] == "SCHEMA" }
    ActiveSupport::Notifications.subscribed(callback, "sql.active_record", &)
    statements
  end
end
