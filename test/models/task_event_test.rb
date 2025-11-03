# == Schema Information
#
# Table name: task_events(タスクイベント)
#
#  id                                 :bigint           not null, primary key
#  due_on_from(変更前の期限)          :date
#  due_on_to(変更後の期限)            :date
#  event_type(イベント種別)           :integer          not null
#  created_at                         :datetime         not null
#  updated_at                         :datetime         not null
#  actor_id(実行者)                   :bigint           not null
#  assignee_from_id(変更前の担当者ID) :bigint
#  assignee_to_id(変更後の担当者ID)   :bigint
#  status_from_id(変更前ステータス)   :integer
#  status_to_id(変更後ステータス)     :integer
#  task_comment_id(関連コメントID)    :bigint
#  task_id(対象タスクID)              :bigint           not null
#  work_id(関連作業ID)                :bigint
#
# Indexes
#
#  index_task_events_on_actor_id                             (actor_id)
#  index_task_events_on_assignee_from_id                     (assignee_from_id)
#  index_task_events_on_assignee_to_id                       (assignee_to_id)
#  index_task_events_on_task_comment_id                      (task_comment_id)
#  index_task_events_on_task_id                              (task_id)
#  index_task_events_on_task_id_and_actor_id_and_updated_at  (task_id,actor_id,updated_at)
#  index_task_events_on_task_id_and_created_at               (task_id,created_at)
#  index_task_events_on_task_id_and_updated_at               (task_id,updated_at)
#  index_task_events_on_work_id                              (work_id)
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

  test "作業削除(タスクが作業追加)" do
    event = task_events(:work_event)
    event.update!(status_from_id: nil, status_to_id: nil, event_type: :add_work)
    assert_difference("TaskEvent.count", -1) do
      event.update!(work: nil)
    end
  end

  test "作業削除(タスクが作業追加以外)" do
    event = task_events(:work_event)
    event.update!(status_from_id: 0, status_to_id: 2, event_type: :change_status)
    assert_no_difference("TaskEvent.count") do
      event.update!(work: nil)
    end
  end
end
