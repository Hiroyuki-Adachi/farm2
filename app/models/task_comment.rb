# == Schema Information
#
# Table name: task_comments(タスクコメント)
#
#  id                    :bigint           not null, primary key
#  body(コメント本文)    :text             default(""), not null
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  poster_id(投稿者ID)   :bigint           not null
#  task_id(対象タスクID) :bigint           not null
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
class TaskComment < ApplicationRecord
  belongs_to :poster, class_name: 'Worker'
  belongs_to :task
  has_one :event, class_name: 'TaskEvent', inverse_of: :comment, dependent: :nullify
  before_validation :strip_body
  after_commit :purge_if_blank, on: [:create, :update]

  validates :body, presence: true, on: :create
  validate :poster_is_actor, if: -> { event.present? }

  private

  def strip_body
    self.body = body.to_s.strip
  end

  def purge_if_blank
    return if body.present?

    event.update(comment: nil) if event.present?
    destroy!
  end

  def poster_is_actor
    errors.add(:poster, "がイベントのアクターではありません") if event.actor_id != poster_id
  end
end
