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
class Task < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Enums::OfficeRole

  attribute :watching, :boolean
  attribute :comment, :string
  attribute :has_work, :boolean
  attribute :unread_count, :integer

  belongs_to :assignee, class_name: 'Worker', optional: true
  belongs_to :creator, class_name: 'Worker', optional: true
  belongs_to :template, class_name: 'TaskTemplate', foreign_key: 'task_template_id', optional: true
  belongs_to_active_hash :status, class_name: 'TaskStatus', foreign_key: 'task_status_id'

  has_many :task_watchers, dependent: :destroy
  has_many :watchers, through: :task_watchers, source: :worker
  has_many :comments, class_name: 'TaskComment', dependent: :destroy
  has_many :events, class_name: 'TaskEvent', dependent: :destroy
  has_many :works, through: :events, source: :work
  has_many :reads, class_name: 'TaskRead', dependent: :destroy

  before_save :clear_end_info
  after_create :create_watcher
  after_create :create_task_event
  after_create :init_task_reads

  enum :priority, { low: 0, medium: 5, high: 8, urgent: 9 }
  enum :end_reason, { unset: 0, completed: 1, no_action: 2, unavailable: 3, duplicated: 4, other: 9 }, prefix: true

  validates :title, presence: true, length: { maximum: 40 }
  validates :task_status_id, presence: true
  validates :priority, presence: true
  validates :end_reason, presence: true

  validate :ended_on_after_started_on

  scope :usual_order, -> { order("priority DESC, due_on ASC NULLS LAST, id ASC") }

  scope :for_index, -> {
    where('task_status_id IN (?) OR (task_status_id IN (?) AND created_at > ?)', TaskStatus.open_ids, TaskStatus.closed_ids, Time.zone.today - 30.days)
    .usual_order
  }

  scope :for_work, ->(work) {
    task_event_table = TaskEvent.arel_table
    task_table = arel_table
    work_result_table = WorkResult.arel_table

    # 日報の作業者
    worker_ids_subq = work_result_table.project(work_result_table[:worker_id]).where(work_result_table[:work_id].eq(work.id))

    # 新しく紐づけ可能なタスクの条件
    new_work_link = task_table[:office_role].eq(work.work_type.office_role) # 役割が一致
              .and(task_table[:office_role].not_eq(Task.office_roles[:none])) # 役割が「なし」ではない
              .and(task_table[:assignee_id].in(worker_ids_subq)) # 作業者が担当者に含まれる

    base = where(task_status_id: TaskStatus.workable_ids).where(new_work_link)
    base.select(task_table[Arel.star])
  }

  scope :opened, -> { where(task_status_id: TaskStatus.open_ids).usual_order }

  scope :by_worker, ->(worker) {
    task_table = arel_table
    task_watcher_table = TaskWatcher.arel_table

    subq = TaskWatcher
            .select(1)
            .where(task_watcher_table[:worker_id].eq(worker.id))
            .where(task_watcher_table[:task_id].eq(task_table[:id]))

    exists = Arel::Nodes::Exists.new(subq.arel)
    participant = Task.where(task_table[:assignee_id].eq(worker.id).or(exists))

    participant
      .where(task_status_id: TaskStatus.open_ids)
      .or(participant.where(task_status_id: TaskStatus.closed_ids, created_at: Time.zone.today.all_day))
      .usual_order
  }
  
  scope :with_watch_flag, ->(worker_id) {
    sql = <<-SQL.squish
      #{table_name}.*, 
      EXISTS (
        SELECT 1 FROM task_watchers tw
        WHERE tw.task_id = #{table_name}.id
          AND tw.worker_id = :worker_id
      ) AS watching
    SQL

    select(Arel.sql(ApplicationRecord.sanitize_sql_array([sql, {worker_id: worker_id}])))
  }

  scope :with_unread_count, ->(worker_id) {
    sql = <<-SQL.squish
      #{table_name}.*, 
      (SELECT COUNT(DISTINCT tc.id) FROM task_reads tr
        LEFT OUTER JOIN task_comments tc ON tc.task_id = #{table_name}.id
          AND tc.poster_id <> :worker_id
        WHERE tr.task_id = #{table_name}.id
          AND tr.worker_id = :worker_id
          AND tr.last_read_at < tc.updated_at
      ) AS unread_count
    SQL

    select(Arel.sql(ApplicationRecord.sanitize_sql_array([sql, {worker_id: worker_id}])))
  }

  def closed?
    self.status.closed_flag
  end

  def start?
    self.status.start_flag
  end

  def started?
    self.status.started_flag
  end

  def opened?
    !self.closed?
  end

  def workable?
    self.status.work_flag
  end

  def overdue?
    return false if due_on.blank?

    due_on < Date.current && !closed?
  end

  # 担当者変更
  def change_assignee!(new_assignee_id, actor, comment = nil)
    self.comment = comment
    if new_assignee_id.to_i == assignee_id.to_i
      errors.add(:assignee_id, "が変更されていません")
      raise ActiveRecord::RecordInvalid, self
    end
    if self.closed?
      errors.add(:assignee_id, "を変更できません（タスクが完了しています）")
      raise ActiveRecord::RecordInvalid, self
    end

    in_change_tx!(actor: actor, comment: comment) do |c|
      events.create!(
        actor: actor, event_type: :change_assignee,
        assignee_from_id: assignee_id, assignee_to_id: new_assignee_id,
        comment: c
      )
      update!(assignee_id: new_assignee_id)

      if new_assignee_id
        TaskWatcher.find_or_create_by!(task: self, worker_id: new_assignee_id)
        TaskRead.touch_and_get_previous!(task: self, worker_id: new_assignee_id, at: Time.at(0))
      end
    end
  end

  # ステータス変更
  def change_status!(new_params, actor)
    self.comment = new_params[:comment]
    new_status = TaskStatus.find_by(code: new_params[:task_status])
    if new_status.nil?
      errors.add(:status, "が不正な値です")
      raise ActiveRecord::RecordInvalid, self
    end
    if new_status.code == self.status.code
      errors.add(:status, "が変更されていません")
      raise ActiveRecord::RecordInvalid, self
    end
    if self.status.next_statuses.pluck(:id).exclude?(new_status.id)
      errors.add(:status, "が不正な値です")
      raise ActiveRecord::RecordInvalid, self
    end

    in_change_tx!(actor: actor, comment: comment) do |c|
      events.create!(
        actor: actor, event_type: :change_status,
        status_from_id: self.task_status_id, status_to_id: new_status.id,
        comment: c
      )
      self.task_status_id = new_status.id
      if new_status.started_flag
        self.started_on = Time.zone.today
      elsif new_status.closed_flag
        self.ended_on = Time.zone.today
        self.started_on ||= Time.zone.today
        self.end_reason = new_params[:end_reason].presence || :other
      end
      self.save!
    end
  end

  # 期限変更
  def change_due_on!(new_due_on, actor, comment = nil)
    self.comment = comment
    if new_due_on.presence&.to_date == due_on
      errors.add(:due_on, "が変更されていません")
      raise ActiveRecord::RecordInvalid, self
    end
    if self.closed?
      errors.add(:due_on, "を変更できません（タスクが完了しています）")
      raise ActiveRecord::RecordInvalid, self
    end

    in_change_tx!(actor: actor, comment: comment) do |c|
      events.create!(
        actor: actor, event_type: :change_due_on,
        due_on_from: due_on, due_on_to: new_due_on,
        comment: c
      )
      update!(due_on: new_due_on)
    end
  end

  def deletable?(user)
    (user.admin? || (self.creator_id == user.worker_id)) && self.opened?
  end

  def watching_by?(user)
    return false if user.nil? || user.worker_id.nil?

    task_watchers.exists?(worker_id: user.worker_id)
  end

  def watching_by(user)
    raise ActiveRecord::RecordInvalid if user.nil? || user.worker_id.nil?

    task_watchers.find_by(worker_id: user.worker_id)
  end

  def create_watcher_by_role
    return if self.office_role_none?

    Worker.where(office_role: self.office_role).find_each do |worker|
      task_watchers.find_or_create_by(worker_id: worker.id)
    end
  end

  def add_comment!(actor:, body:)
    comment = self.comments.create!(poster: actor, body: body)
    TaskEvent.create!(task: self, actor: actor, event_type: :add_comment, comment: comment)
  end

  def add_work!(actor:, work:, close: false)
    if close
      TaskEvent.create!(task: self, actor: actor, event_type: :change_status, status_from: status, status_to: TaskStatus::DONE, work: work)
      update!(status: TaskStatus::DONE, started_on: started_on || work.worked_at, ended_on: work.worked_at, end_reason: :completed)
      return
    end
    if status == TaskStatus::DOING
      TaskEvent.create!(task: self, actor: actor, event_type: :add_work, work: work)
    elsif [TaskStatus::TO_DO, TaskStatus::REOPEN].include?(status)
      TaskEvent.create!(task: self, actor: actor, event_type: :change_status, status_from: status, status_to: TaskStatus::DOING, work: work)
      update!(status: TaskStatus::DOING, started_on: work.worked_at)
    else
      raise "Cannot add work when task status is #{status.name}"
    end
  end

  def remove_work!(work:)
    event = TaskEvent.find_by(task: self, work: work)
    return if event.nil?

    if event.last? && event.change_status?
      self.update!(status: event.status_from)
      event.status_to = nil
      event.status_from = nil
      event.event_type = :add_work
    end
    event.work_id = nil
    event.save!
  end

  def self.add_works!(actor:, check_task_ids:, close_task_ids: [], work:)
    ActiveRecord::Base.transaction do
      Task.where(id: check_task_ids).find_each do |task|
        task.add_work!(actor: actor, work: work, close: close_task_ids.include?(task.id.to_s)) if !task.has_work
      end
    end
  end

  private

  # 共通ラッパ：コメントを（あれば）作ってトランザクション内でyield
  def in_change_tx!(actor:, comment:)
    transaction do
      created_comment =
        comment.present? ? TaskComment.create!(task: self, poster_id: actor.id, body: comment) : nil
      yield(created_comment)
    end
    true
  end

  def ended_on_after_started_on
    return if ended_on.blank? || started_on.blank?

    errors.add(:ended_on, "は着手日以降の日付にしてください。") if ended_on < started_on
  end

  def end_reason_for_closed
    return if self.opened?

    errors.add(:end_reason, "を選択してください。") if self.end_reason_unset?
  end

  def clear_end_info
    unless self.closed?
      self.end_reason = :unset
      self.ended_on = nil
    end
    self.started_on = nil if self.start?
  end

  def create_watcher
    self.task_watchers.find_or_create_by(worker_id: self.assignee_id) if self.assignee.present?
    self.task_watchers.find_or_create_by(worker_id: self.creator_id) if self.creator.present?
  end

  def create_task_event
    return if self.creator.nil?

    TaskEvent.create!(
      task: self,
      actor: self.creator,
      event_type: :task_created
    )
  end

  def init_task_reads
    return if self.creator.blank?
    TaskRead.touch_and_get_previous!(task: self, worker_id: self.creator_id, at: self.created_at)
    return if self.assignee.blank? || self.assignee_id == self.creator_id
    TaskRead.touch_and_get_previous!(task: self, worker_id: self.assignee_id, at: Time.at(0))
  end
end
