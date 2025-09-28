# == Schema Information
#
# Table name: task_comments
#
#  id                  :bigint           not null, primary key
#  body(コメント本文)  :text             default(""), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  poster_id(投稿者)   :bigint           not null
#  task_id(対象タスク) :bigint           not null
#
# Indexes
#
#  index_task_comments_on_poster_id                             (poster_id)
#  index_task_comments_on_task_id                               (task_id)
#  index_task_comments_on_task_id_and_created_at                (task_id,created_at)
#  index_task_comments_on_task_id_and_poster_id_and_updated_at  (task_id,poster_id,updated_at)
#  index_task_comments_on_task_id_and_updated_at                (task_id,updated_at)
#
# Foreign Keys
#
#  fk_rails_...  (poster_id => workers.id)
#  fk_rails_...  (task_id => tasks.id)
#
require "test_helper"

class TaskCommentTest < ActiveSupport::TestCase
  setup do
    @comment = task_comments(:one_day_ago_comment)
    @event = @comment.event
  end

  test "コメント削除(タスクがコメント追加)" do
    @event.update!(due_on_from: nil, due_on_to: nil, event_type: :add_comment)
    assert_difference("TaskComment.count", -1) do
      assert_difference("TaskEvent.count", -1) do
        @comment.update(body: '')
      end
    end
  end

  test "コメント削除(タスクがコメント追加以外)" do
    @event.update!(due_on_from: Date.current + 1.day, due_on_to: Date.current + 2.days, event_type: :change_due_on)
    assert_difference("TaskComment.count", -1) do
      assert_no_difference("TaskEvent.count") do
        @comment.update(body: '')
      end
    end
  end

  test "コメント変更" do
    assert_no_difference("TaskComment.count") do
      assert_no_difference("TaskEvent.count") do
        @comment.update(body: 'ABC')
      end
    end
  end
end
