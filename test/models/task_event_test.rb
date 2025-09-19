# == Schema Information
#
# Table name: task_events(タスクイベント)
#
#  id                               :bigint           not null, primary key
#  due_on_from(変更前の期限)        :date
#  due_on_to(変更後の期限)          :date
#  event_type(イベント種別)         :integer          not null
#  created_at                       :datetime         not null
#  updated_at                       :datetime         not null
#  actor_id(実行者)                 :bigint           not null
#  assignee_from_id(変更前の担当者) :bigint
#  assignee_to_id(変更後の担当者)   :bigint
#  status_from_id(変更前ステータス) :integer
#  status_to_id(変更後ステータス)   :integer
#  task_comment_id(関連コメント)    :bigint
#  task_id(対象タスク)              :bigint           not null
#  work_id(関連作業)                :bigint
#
# Indexes
#
#  index_task_events_on_actor_id                (actor_id)
#  index_task_events_on_assignee_from_id        (assignee_from_id)
#  index_task_events_on_assignee_to_id          (assignee_to_id)
#  index_task_events_on_task_comment_id         (task_comment_id)
#  index_task_events_on_task_id                 (task_id)
#  index_task_events_on_task_id_and_created_at  (task_id,created_at)
#  index_task_events_on_work_id                 (work_id)
#
# Foreign Keys
#
#  fk_rails_...  (actor_id => workers.id)
#  fk_rails_...  (assignee_from_id => workers.id)
#  fk_rails_...  (assignee_to_id => workers.id)
#  fk_rails_...  (task_comment_id => task_comments.id)
#  fk_rails_...  (task_id => tasks.id)
#  fk_rails_...  (work_id => works.id)
#
require "test_helper"

class TaskEventTest < ActiveSupport::TestCase
  test "コメント削除(タスクがコメント追加)" do
    event = task_events(:comment_event)
    event.update!(due_on_from: nil, due_on_to: nil, event_type: :add_comment)
    assert_difference("TaskEvent.count", -1) do
      event.update!(comment: nil)
    end
  end

  test "コメント削除(タスクがコメント追加以外)" do
    event = task_events(:comment_event)
    event.update!(due_on_from: Date.current + 1.day, due_on_to: Date.current + 2.days, event_type: :change_due_on)
    assert_no_difference("TaskEvent.count") do
      event.update!(comment: nil)
    end
  end

  test "コメント追加" do
    task = tasks(:open_task)
    worker = workers(:worker1)
    comment = '新しいコメント'
    assert_difference("TaskEvent.count", 1) do
      assert_difference("TaskComment.count", 1) do
        TaskEvent.add_comment!(task: task, actor: worker, body: comment)
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
end
