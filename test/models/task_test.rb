# == Schema Information
#
# Table name: tasks(タスク)
#
#  id                             :bigint           not null, primary key
#  description(説明)              :text             default(""), not null
#  due_on(期限)                   :date
#  end_reason(完了理由)           :integer          default("unset"), not null
#  ended_on(完了日)               :date
#  office_role(役割)              :integer          default("none"), not null
#  priority(優先度)               :integer          default("low"), not null
#  started_on(着手日)             :date
#  title(タスク名)                :string(64)       default(""), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  assignee_id(担当者)            :bigint
#  creator_id(作成者)             :bigint
#  task_status_id(状態)           :integer          default(0), not null
#  task_template_id(定型タスクID) :bigint
#
# Indexes
#
#  index_tasks_on_assignee_id       (assignee_id)
#  index_tasks_on_creator_id        (creator_id)
#  index_tasks_on_task_template_id  (task_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => workers.id)
#  fk_rails_...  (creator_id => workers.id)
#  fk_rails_...  (task_template_id => task_templates.id)
#
require "test_helper"

class TaskTest < ActiveSupport::TestCase
  fixtures :workers, :tasks

  test "fixtureの妥当性検証" do
    assert tasks(:open_task).valid?
    assert tasks(:started_task).valid?
    assert tasks(:closed_task).valid?
  end

  test "タスク名検証" do
    new_task = Task.new(title: "", task_status_id: 0, priority: :low, end_reason: :unset)
    assert_not new_task.valid?

    new_task.title = "a" * 41
    assert_not new_task.valid?
  end

  test "タスク新規作成処理" do
    worker2 = workers(:worker2)

    created_task = Task.create!(
      title: "new task",
      task_status_id: 0,
      priority: :low,
      end_reason: :unset,
      assignee_id: worker2.id,
      creator_id: worker2.id
    )

    assert created_task.task_watchers.exists?(worker_id: worker2.id)

    # 作成イベントが出ている
    assert_equal 1, created_task.events.where(event_type: :task_created).count

    # 既読が作成されている
    assert_equal 1, created_task.reads.where(worker_id: worker2.id).count
  end

  test "担当者変更処理" do
    worker1 = workers(:worker1)
    worker2 = workers(:worker2)
    open_task = tasks(:open_task)
    comment = "引き継ぎます"

    assert_difference("TaskRead.count", 1) do
      assert_changes -> { open_task.reload.assignee_id }, to: worker2.id do
        open_task.change_assignee!(worker2.id, worker1, comment)
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
      open_task.change_assignee!(worker1.id, worker1, "同じ人です")
    end
    assert open_task.errors.any?
  end

  test "担当者変更処理(完了済)" do
    worker2 = workers(:worker2)
    closed_task = tasks(:closed_task)

    assert_raises(ActiveRecord::RecordInvalid) do
      closed_task.change_assignee!(worker2.id, worker2, "完了済です")
    end
    assert closed_task.errors.any?
  end

  test "期限変更" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    new_due = Date.current + 7.days
    comment = "期限を合わせます"

    assert_changes -> { open_task.reload.due_on }, to: new_due do
      open_task.change_due_on!(new_due, worker1, comment)
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
      open_task.change_due_on!(nil, worker1)
    end
    assert open_task.errors.any?
  end

  test "期限変更(完了済)" do
    worker1 = workers(:worker1)
    closed_task = tasks(:closed_task)
    closed_task.update!(due_on: Time.zone.yesterday)

    assert_raises(ActiveRecord::RecordInvalid) do
      closed_task.change_due_on!(Time.zone.today, worker1)
    end
    assert closed_task.errors.any?
  end

  test "ステータス変更(未着手⇒進行中)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    comment = "開始します"
    params = { task_status: :doing, comment: comment }

    assert_changes -> { open_task.reload.task_status_id }, to: TaskStatus::DOING.id do
      open_task.change_status!(params, worker1)
    end
    assert_equal Date.current, open_task.started_on

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
      started_task.change_status!(params, worker1)
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
      open_task.change_status!(params, worker1)
    end
    assert open_task.errors.any?
  end

  test "ステータス変更(同じ値)" do
    worker1 = workers(:worker1)
    open_task = tasks(:open_task)
    params = { task_status: :to_do }

    assert_raises(ActiveRecord::RecordInvalid) do
      open_task.change_status!(params, worker1)
    end
    assert open_task.errors.any?
  end

  test "ステータス変更(禁止ルール抵触)" do
    worker1 = workers(:worker1)

    # OK例（to_do -> cancel）
    task1 = tasks(:open_task)
    assert_changes -> { task1.reload.task_status_id }, to: TaskStatus::CANCEL.id do
      task1.change_status!({ task_status: :cancel, comment: "中止します" }, worker1)
    end

    # NG例（hold -> to_do）
    task2 = tasks(:open_task)
    task2.update!(task_status_id: TaskStatus::HOLD.id)
    assert_raises(ActiveRecord::RecordInvalid) do
      task2.change_status!({ task_status: :to_do }, worker1)
    end
    assert task2.errors.any?
  end
  
  test "コメント追加" do
    task = tasks(:open_task)
    worker = workers(:worker1)
    comment = '新しいコメント'
    assert_difference("TaskEvent.count", 1) do
      assert_difference("TaskComment.count", 1) do
        task.add_comment!(actor: worker, body: comment)
      end
    end

    created_event = TaskEvent.last
    assert_equal worker.id, created_event.actor_id
    assert_equal task.id, created_event.task_id
    assert created_event.add_comment?

    created_comment = TaskComment.last
    assert_equal comment, created_comment.body
    assert_equal worker.id, created_comment.poster_id
    assert_equal task.id, created_comment.task_id

    assert_equal created_comment.id, created_event.task_comment_id
  end

  test "作業追加(ステータスが対応中)" do
    task = tasks(:started_task)
    worker = workers(:worker1)
    work = works(:works1)

    assert_difference("TaskEvent.count", 1) do
      task.add_work!(actor: worker, work: work)
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

    assert_difference("TaskEvent.count", 1) do
      task.add_work!(actor: worker, work: work)
    end

    created_event = TaskEvent.last
    assert_equal worker.id, created_event.actor_id
    assert_equal task.id, created_event.task_id
    assert created_event.change_status?
    assert_equal work.id, created_event.work_id
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
      task.add_work!(actor: worker, work: work, close: true)
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
      assert_nil task.remove_work!(work: work)
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
      task.remove_work!(work: work)
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
      task.remove_work!(work: work)
    end

    task.reload
    assert_equal TaskStatus::TO_DO.id, task.task_status_id
  end
end
