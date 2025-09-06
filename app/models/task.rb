# == Schema Information
#
# Table name: tasks(タスク)
#
#  id                   :bigint           not null, primary key
#  description(説明)    :text             not null
#  due_on(期限)         :date
#  end_reason(完了理由) :integer          default("unset"), not null
#  ended_on(完了日)     :date
#  office_role(役割)    :integer          default(0), not null
#  priority(優先度)     :integer          default("low"), not null
#  started_on(着手日)   :date
#  status(状態)         :integer          default("to_do"), not null
#  title(タスク名)      :string(64)       not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assignee_id(担当者)  :bigint
#  creator_id(作成者)   :bigint           not null
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
  include Enums::OfficeRole

  belongs_to :assignee, class_name: 'Worker', optional: true
  belongs_to :creator, class_name: 'Worker'

  enum :status, { to_do: 0, doing: 1, hold: 2, done: 3, cancel: 9 }
  enum :priority, { low: 0, medium: 5, high: 8, urgent: 9 }
  enum :end_reason, { unset: 0, completed: 1, no_action: 2, unavailable: 3, duplicate: 4, other: 9 }

  validates :title, presence: true, length: { maximum: 64 }
  validates :status, presence: true
  validates :priority, presence: true
  validates :end_reason, presence: true

  validate :ended_on_after_started_on
  validate :due_on_after_started_on

  def closed?
    self.done? || self.cancel?
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
end
