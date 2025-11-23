# == Schema Information
#
# Table name: tasks(タスク)
#
#  id                              :bigint           not null, primary key
#  description(説明)               :text             default(""), not null
#  due_on(期限)                    :date
#  end_reason(完了理由)            :integer          default("unset"), not null
#  ended_on(完了日)                :date
#  kanban_position(カンバンの位置) :integer          default(0), not null
#  office_role(役割)               :integer          default("none"), not null
#  planned_start_on(開始予定日)    :date             default(Mon, 01 Jan 1900), not null
#  priority(優先度)                :integer          default("low"), not null
#  started_on(着手日)              :date
#  title(タスク名)                 :string(64)       default(""), not null
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  assignee_id(担当者)             :bigint
#  creator_id(作成者)              :bigint
#  task_status_id(状態)            :integer          default(0), not null
#  task_template_id(定型タスクID)  :bigint
#
# Indexes
#
#  index_tasks_on_assignee_id                         (assignee_id)
#  index_tasks_on_creator_id                          (creator_id)
#  index_tasks_on_task_status_id_and_kanban_position  (task_status_id,kanban_position)
#  index_tasks_on_task_template_id                    (task_template_id)
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
  after_create :create_planned_start_on
  after_create :init_task_reads

  enum :priority, { low: 0, medium: 5, high: 8, urgent: 9 }
  enum :end_reason, { unset: 0, completed: 1, no_action: 2, unavailable: 3, duplicated: 4, other: 9 }, prefix: true

  validates :title, presence: true, length: { maximum: 40 }
  validates :task_status_id, presence: true
  validates :priority, presence: true
  validates :end_reason, presence: true

  validate :ended_on_after_started_on
  validate :ended_on_after_planned_start_on

  scope :usual_order, -> do
    pairs = TaskStatus.all.map { |s| [s.id, s.display_order] }
    values_sql = pairs.map { |id, display_order| "(#{Integer(id)}, #{Integer(display_order)})" }.join(",")

    joins("JOIN (VALUES #{values_sql}) AS statuses(id, display_order) ON statuses.id = tasks.task_status_id")
      .order(Arel.sql("COALESCE(statuses.display_order, 99999999) ASC, due_on ASC NULLS LAST, priority DESC, tasks.id ASC"))
  end

  scope :kanban_order, -> { order(:kanban_position, :id) }
  scope :gantts_order, -> { order(:due_on, :planned_start_on, :id)}

  scope :for_index, ->(days: 30) do
    cutoff     = Time.zone.now - days.days
    closed_ids = TaskStatus.closed_ids

    task = Task.arel_table
    task_event = TaskEvent.arel_table
    task_comment = TaskComment.arel_table

    # --- EXISTS句を事前に定義 ---
    exists_event = task_event
      .project(Arel.star)
      .where(task_event[:task_id].eq(task[:id]).and(task_event[:updated_at].gt(cutoff)))
      .exists

    exists_comment = task_comment
      .project(Arel.star)
      .where(task_comment[:task_id].eq(task[:id]).and(task_comment[:updated_at].gt(cutoff)))
      .exists

    # --- 条件句を組み立て ---
    not_closed = task[:task_status_id].not_in(closed_ids)
    recent_activity =
      task[:updated_at].gt(cutoff)
      .or(exists_event)
      .or(exists_comment)

    closed_and_recent = task[:task_status_id].in(closed_ids).and(recent_activity)

    where(not_closed.or(closed_and_recent)).usual_order
  end

  scope :for_work, ->(work) do
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
  end

  scope :opened, -> { where(task_status_id: TaskStatus.open_ids).usual_order }

  scope :by_worker, ->(worker) do
    task_table = arel_table
    task_watcher_table = TaskWatcher.arel_table

    subq = TaskWatcher
            .select(1)
            .where(task_watcher_table[:worker_id].eq(worker.id))
            .where(task_watcher_table[:task_id].eq(task_table[:id]))

    exists = Arel::Nodes::Exists.new(subq.arel)
    where(task_table[:assignee_id].eq(worker.id).or(exists)).includes(:assignee)
  end
  
  scope :with_watch_flag, ->(worker_id) do
    sql = <<-SQL.squish
      #{table_name}.*, 
      EXISTS (
        SELECT 1 FROM task_watchers tw
        WHERE tw.task_id = #{table_name}.id
          AND tw.worker_id = :worker_id
      ) AS watching
    SQL

    select(Arel.sql(ApplicationRecord.sanitize_sql_array([sql, {worker_id: worker_id}])))
  end

  scope :with_unread_count, ->(worker_id) do
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
  end

  scope :for_kanban, ->(kanban_column) { where(task_status_id: TaskStatus.kanban_column_ids(kanban_column)) }
  scope :kanban_todo, -> { for_kanban(TaskStatus::KANBAN_TODO) }
  scope :kanban_doing, -> { for_kanban(TaskStatus::KANBAN_DOING) }
  scope :kanban_done, ->(days: 15) { for_kanban(TaskStatus::KANBAN_DONE).where(ended_on: (Time.zone.today - days.days)..) }

  scope :for_gantt, ->(start_date, end_date) do
    where(
      arel_table[:planned_start_on].lteq(end_date)
        .and(arel_table[:due_on].gteq(start_date))
    )
  end

  # ステータス判定メソッド群
  def closed?
    self.status.closed_flag
  end

  def start?
    self.status.start_flag
  end

  def started?
    self.status.started_flag
  end

  def open?
    self.status.open_flag
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
        actor: actor,
        event_type: :change_status,
        status_from_id: self.task_status_id,
        status_to_id: new_status.id,
        comment: c,
        source: :form
      )
      self.update_for_start_or_end(new_status, new_params[:end_reason])
      self.save!
    end
  end

  # 期限変更
  def change_due_on!(new_due_on, actor, comment: nil, source: :form)
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
        comment: c,
        source: source
      )
      update!(due_on: new_due_on)
    end
  end

  def deletable?(user)
    (user.admin? || (self.creator_id == user.worker_id)) && !self.closed?
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
    TaskEvent.create!(task: self, actor: actor, event_type: :add_comment, comment: comment, source: :form)
  end

  def add_work!(actor:, work:, close: false, comment: nil)
    if ActiveRecord::Base.connection.transaction_open?
      add_work_core!(actor: actor, work: work, close: close, comment: comment)
    else 
      ActiveRecord::Base.transaction { add_work_core!(actor: actor, work: work, close: close, comment: comment) }
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

  def self.add_works!(actor:, check_task_ids:, work:, close_task_ids: [], task_comments: {})
    ActiveRecord::Base.transaction do
      Task.where(id: check_task_ids).find_each do |task|
        next if task.events.exists?(work_id: work.id)

        task.add_work!(
          actor: actor,
          work: work,
          close: close_task_ids.include?(task.id.to_s),
          comment: task_comments[task.id.to_s] || task_comments[task.id]
        )
      end
    end
  end

  def move_on_kanban!(new_kanban_column, new_position, actor:)
    self.class.transaction do
      old_status_id = self.task_status_id
      old_kanban_column = TaskStatus.find_by(id: old_status_id)&.kanban_column

      if old_kanban_column == new_kanban_column
        update!(kanban_position: new_position)
      else
        new_status = TaskStatus.kanban_status(old_status_id, new_kanban_column)
        self.kanban_position = new_position
        self.update_for_start_or_end(new_status, :completed)
        self.save!
        TaskEvent.create!(
          task_id: id,
          actor_id: actor.id,
          event_type: :change_status, 
          status_from_id: old_status_id,
          status_to_id: new_status.id,
          source: :kanban
        )
      end
    end
  end

  def gantt_end_on
    # 期日があれば、それを尊重
    return ended_on if closed? && ended_on.present?
    return due_on if due_on.present?

    if planned_start_on == Date.new(1900, 1, 1)
      Date.current
    else
      planned_start_on
    end
  end

  def gantt_period
    (planned_start_on..gantt_end_on)
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

  def add_work_core!(actor:, work:, close: false, comment: nil)
    task_comment = comment.present? ? self.comments.create!(poster: actor, body: comment) : nil
    if close
      TaskEvent.create!(task: self, actor: actor, event_type: :change_status, status_from: status, status_to: TaskStatus::DONE, work: work, comment: task_comment, source: :form)
      update!(status: TaskStatus::DONE, started_on: started_on || work.worked_at, ended_on: work.worked_at, end_reason: :completed)
      return
    end
    if status == TaskStatus::DOING
      TaskEvent.create!(task: self, actor: actor, event_type: :add_work, work: work, comment: task_comment, source: :form)
    elsif [TaskStatus::TO_DO, TaskStatus::REOPEN].include?(status)
      TaskEvent.create!(task: self, actor: actor, event_type: :change_status, status_from: status, status_to: TaskStatus::DOING, work: work, comment: task_comment, source: :form)
      update!(status: TaskStatus::DOING, started_on: work.worked_at)
    else
      raise "Cannot add work when task status is #{status.name}"
    end
  end

  def ended_on_after_started_on
    return if ended_on.blank? || started_on.blank?

    errors.add(:ended_on, "は着手日以降の日付にしてください。") if ended_on < started_on
  end

  def ended_on_after_planned_start_on
    return if ended_on.blank?

    errors.add(:ended_on, "は開始予定日以降の日付にしてください。") if ended_on < planned_start_on
  end

  def end_reason_for_closed
    return unless self.closed?

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
      event_type: :task_created,
      source: :form
    )
  end

  def init_task_reads
    return if self.creator.blank?
    TaskRead.touch_and_get_previous!(task: self, worker_id: self.creator_id, at: self.created_at)
    return if self.assignee.blank? || self.assignee_id == self.creator_id
    TaskRead.touch_and_get_previous!(task: self, worker_id: self.assignee_id, at: Time.at(0))
  end

  def update_for_start_or_end(new_status, end_reason)
    self.task_status_id = new_status.id
    if new_status.started_flag
      self.started_on ||= Time.zone.today
    elsif new_status.closed_flag
      self.ended_on = Time.zone.today
      self.started_on ||= Time.zone.today
      self.end_reason = end_reason || :other
    end
  end

  def create_planned_start_on
    self.update(planned_start_on: self.created_at.to_date)
  end
end
