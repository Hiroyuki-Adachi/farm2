# == Schema Information
#
# Table name: task_events(タスクイベント)
#
#  id                                 :bigint           not null, primary key
#  due_on_from(変更前の期限)          :date
#  due_on_to(変更後の期限)            :date
#  event_type(イベント種別)           :integer          not null
#  source(ソース)                     :integer          default("form"), not null
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
  test "with_read_infoはコメント既読情報を返す" do
    task = tasks(:comment_task)
    reader = workers(:worker1)
    poster = workers(:worker2)
    other_reader = workers(:worker3)
    commented_at = Time.zone.local(2026, 1, 1, 10, 0, 0)
    comment = TaskComment.create!(task: task, poster: poster, body: "確認お願いします", created_at: commented_at, updated_at: commented_at)
    event = TaskEvent.create!(task: task, actor: poster, comment: comment, event_type: :add_comment, created_at: commented_at, updated_at: commented_at)

    TaskRead.find_or_create_by!(task: task, worker: other_reader).update!(last_read_at: commented_at)

    unread_result = TaskEvent.with_read_info(reader.id, commented_at - 1.second).find(event.id)

    assert_equal 1, unread_result.read_count
    assert_includes unread_result.reader_names, "#{other_reader.family_name} #{other_reader.first_name}"
    assert unread_result.unread_flag
    assert_not unread_result.mine_flag

    read_result = TaskEvent.with_read_info(reader.id, commented_at).find(event.id)

    assert_not read_result.unread_flag
  end

  test "with_read_infoは既読者がいない場合もread_countを0にする" do
    task = tasks(:open_task)
    worker = workers(:worker1)
    event = TaskEvent.create!(task: task, actor: worker, event_type: :change_status, created_at: Time.current, updated_at: Time.current)

    result = TaskEvent.with_read_info(worker.id, Time.current).find(event.id)

    assert_equal 0, result.read_count
    assert result.mine_flag
  end

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
