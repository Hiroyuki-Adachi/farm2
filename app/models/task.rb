# == Schema Information
#
# Table name: tasks(タスク)
#
#  id                   :bigint           not null, primary key
#  description(説明)    :text             default(""), not null
#  due_on(期限)         :date
#  end_reason(完了理由) :integer          default("unset"), not null
#  ended_on(完了日)     :date
#  office_role(役割)    :integer          default("none"), not null
#  priority(優先度)     :integer          default("low"), not null
#  started_on(着手日)   :date
#  title(タスク名)      :string(64)       default(""), not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assignee_id(担当者)  :bigint
#  creator_id(作成者)   :bigint
#  task_status_id(状態) :integer          default(0), not null
#
# Indexes
#
#  index_tasks_on_assignee_id  (assignee_id)
#  index_tasks_on_creator_id   (creator_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => workers.id)
#  fk_rails_...  (creator_id => workers.id)
#
class Task < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Enums::OfficeRole

  belongs_to :assignee, class_name: 'Worker', optional: true
  belongs_to :creator, class_name: 'Worker', optional: true
  belongs_to_active_hash :task_status

  before_save :clear_end_reason

  enum :priority, { low: 0, medium: 5, high: 8, urgent: 9 }
  enum :end_reason, { unset: 0, completed: 1, no_action: 2, unavailable: 3, duplicate: 4, other: 9 }

  validates :title, presence: true, length: { maximum: 40 }
  validates :task_status_id, presence: true
  validates :priority, presence: true
  validates :end_reason, presence: true

  validate :ended_on_after_started_on
  validate :due_on_after_started_on

  scope :usual_order, -> { order("priority DESC, due_on ASC NULLS LAST, id ASC") }

  scope :for_index, -> {
    where('task_status_id IN (?) OR (task_status_id IN (?) AND created_at > ?)', TaskStatus.open_ids, TaskStatus.closed_ids, Time.zone.today - 30.days)
    .usual_order
  }

  scope :by_worker, ->(worker) {
    participant =
      Task.where(assignee_id: worker.id)
          .or(Task.where(creator_id: worker.id))
          .or(Task.where(office_role: worker.office_role))

    participant
      .where(task_status_id: TaskStatus.open_ids)
      .or(participant.where(task_status_id: TaskStatus.closed_ids, created_at: Time.zone.today.all_day))
      .usual_order
  }

  def closed?
    TaskStatus.closed_ids.include?(self.task_status_id)
  end

  def overdue?
    return false if due_on.blank?

    due_on < Date.current && !closed?
  end

  private

  def ended_on_after_started_on
    return if ended_on.blank? || started_on.blank?

    errors.add(:ended_on, "は着手日以降の日付にしてください。") if ended_on < started_on
  end

  def due_on_after_started_on
    return if due_on.blank? || started_on.blank?

    errors.add(:due_on, "は着手日以降の日付にしてください。") if due_on < started_on
  end

  def clear_end_reason
    self.end_reason = :unset unless self.closed?
  end
end
