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
#  index_task_comments_on_poster_id               (poster_id)
#  index_task_comments_on_task_id                 (task_id)
#  index_task_comments_on_task_id_and_created_at  (task_id,created_at)
#
# Foreign Keys
#
#  fk_rails_...  (poster_id => workers.id)
#  fk_rails_...  (task_id => tasks.id)
#
class TaskComment < ApplicationRecord
  belongs_to :poster, class_name: 'Worker'
  belongs_to :task

  after_create :notify_task_event

  private

  def notify_task_event
    TaskEvent.create(
      task: task,
      actor: poster,
      event_type: :comment_added,
      task_comment: self
    )
  end
end
