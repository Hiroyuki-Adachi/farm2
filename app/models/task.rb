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

  has_many :task_watchers, dependent: :destroy
  has_many :watchers, through: :task_watchers, source: :worker
  has_many :task_comments, dependent: :destroy
  has_many :task_events, dependent: :destroy

  before_save :clear_end_reason
  before_save :create_watcher
  after_create :notify_task_event_for_create
  after_update :notify_task_event_for_update

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

  scope :opened, -> { where(task_status_id: TaskStatus.open_ids).usual_order }

  scope :by_worker, ->(worker) {
    t  = arel_table
    tw = TaskWatcher.arel_table

    subq = TaskWatcher
            .select(1)
            .where(tw[:worker_id].eq(worker.id))
            .where(tw[:task_id].eq(t[:id]))

    exists = Arel::Nodes::Exists.new(subq.arel)
    participant = Task.where(t[:assignee_id].eq(worker.id).or(exists))

    participant
      .where(task_status_id: TaskStatus.open_ids)
      .or(participant.where(task_status_id: TaskStatus.closed_ids, created_at: Time.zone.today.all_day))
      .usual_order
  }

  attr_accessor :updated_by

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

  def create_watcher
    self.task_watchers.find_or_create_by(worker: self.assignee_id) if self.assignee_id.present?
    self.task_watchers.find_or_create_by(worker: self.creator_id) if self.creator_id.present?
  end

  def notify_task_event_for_create
    return if self.creator.nil?
    TaskEvent.create(
      task: self,
      actor: self.creator,
      event_type: :task_created,
      status_to: self.task_status_id,
      assignee_to: self.assignee,
      due_on_to: self.due_on
    )
  end

  def notify_task_event_for_update
    return if self.creator.nil?

    if self.saved_change_to_task_status_id?
      TaskEvent.create(
        task: self,
        actor: self.updated_by,
        event_type: :status_changed,
        status_from_id: self.task_status_id_before_last_save,
        status_to_id: self.task_status_id
      )
    end

    if self.saved_change_to_assignee_id?
      TaskEvent.create(
        task: self,
        actor: self.updated_by,
        event_type: :assignee_changed,
        assignee_from_id: self.assignee_id_before_last_save,
        assignee_to_id: self.assignee_id
      )
    end

    if self.saved_change_to_due_on?
      TaskEvent.create(
        task: self,
        actor: self.updated_by,
        event_type: :due_on_changed,
        due_on_from: self.due_on_before_last_save,
        due_on_to: self.due_on
      )
    end
  end
end
