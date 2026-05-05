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
#  organization_id(組織)           :bigint           default(3), not null
#  task_status_id(状態)            :integer          default(0), not null
#  task_template_id(定型タスクID)  :bigint
#
# Indexes
#
#  index_tasks_on_assignee_id                         (assignee_id)
#  index_tasks_on_creator_id                          (creator_id)
#  index_tasks_on_organization_id                     (organization_id)
#  index_tasks_on_organization_id_and_task_status_id  (organization_id,task_status_id)
#  index_tasks_on_task_status_id_and_kanban_position  (task_status_id,kanban_position)
#  index_tasks_on_task_template_id                    (task_template_id)
#
# Foreign Keys
#
#  fk_rails_...  (assignee_id => workers.id)
#  fk_rails_...  (creator_id => workers.id)
#  fk_rails_...  (organization_id => organizations.id)
#  fk_rails_...  (task_template_id => task_templates.id)
#
class Task < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
  include Enums::OfficeRole

  UNDEFINED_DATE = Date.new(1900, 1, 1)

  attribute :watching, :boolean
  attribute :comment, :string
  attribute :unread_count, :integer

  belongs_to :assignee, class_name: 'Worker', optional: true
  belongs_to :creator, class_name: 'Worker', optional: true
  belongs_to :template, class_name: 'TaskTemplate', foreign_key: 'task_template_id', optional: true
  belongs_to :organization
  belongs_to_active_hash :status, class_name: 'TaskStatus', foreign_key: 'task_status_id'

  has_many :task_watchers, dependent: :destroy
  has_many :watchers, through: :task_watchers, source: :worker
  has_many :comments, class_name: 'TaskComment', dependent: :destroy
  has_many :events, class_name: 'TaskEvent', dependent: :destroy
  has_many :works, through: :events, source: :work
  has_many :reads, class_name: 'TaskRead', dependent: :destroy

  before_validation :set_organization
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

  validate :members_belong_to_same_organization
  validate :ended_on_after_started_on
  validate :ended_on_after_planned_start_on

  scope :for_organization, ->(organization) { where(organization_id: organization.is_a?(Organization) ? organization.id : organization) }

  scope :usual_order, lambda {
    pairs = TaskStatus.all.map { |s| [s.id, s.display_order] }
    values_sql = pairs.map { |id, display_order| "(#{Integer(id)}, #{Integer(display_order)})" }.join(",")

    joins("JOIN (VALUES #{values_sql}) AS statuses(id, display_order) ON statuses.id = tasks.task_status_id")
      .order(Arel.sql("COALESCE(statuses.display_order, 99999999) ASC, due_on ASC NULLS LAST, priority DESC, tasks.id ASC"))
  }

  scope :kanban_order, -> { order(:kanban_position, :id) }
  scope :gantts_order, -> { order(:due_on, :planned_start_on, :id) }

  scope :for_index, lambda { |days: 30|
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
  }

  scope :for_work, lambda { |work|
    task_table = arel_table
    work_result_table = WorkResult.arel_table

    # 日報の作業者
    worker_ids_subq = work_result_table.project(work_result_table[:worker_id]).where(work_result_table[:work_id].eq(work.id))

    # 新しく紐づけ可能なタスクの条件
    new_work_link = task_table[:office_role].eq(work.work_type.office_role) # 役割が一致
      .and(task_table[:office_role].not_eq(Task.office_roles[:none])) # 役割が「なし」ではない
      .and(task_table[:assignee_id].in(worker_ids_subq)) # 作業者が担当者に含まれる
      .and(task_table[:planned_start_on].lteq(work.worked_at)) # 作業日までに開始予定

    base = where(task_status_id: TaskStatus.workable_ids).where(new_work_link)
    base.select(task_table[Arel.star])
  }

  scope :opened, -> { where(task_status_id: TaskStatus.open_ids).usual_order }
  scope :planned_start, -> { where(planned_start_on: ..Time.zone.today) }

  scope :by_worker, lambda { |worker|
    task_table = arel_table
    task_watcher_table = TaskWatcher.arel_table

    subq = TaskWatcher
      .select(1)
      .where(task_watcher_table[:worker_id].eq(worker.id))
      .where(task_watcher_table[:task_id].eq(task_table[:id]))

    exists = Arel::Nodes::Exists.new(subq.arel)
    where(task_table[:assignee_id].eq(worker.id).or(exists)).includes(:assignee)
  }

  scope :with_watch_flag, lambda { |worker_id|
    tasks = arel_table
    task_watchers = TaskWatcher.arel_table
    watching_exists = task_watchers
      .project(Arel.sql("1"))
      .where(
        task_watchers[:task_id].eq(tasks[:id])
          .and(task_watchers[:worker_id].eq(worker_id))
      )
      .exists

    select(
      tasks[Arel.star],
      Arel::Nodes::As.new(watching_exists, Arel.sql("watching"))
    )
  }

  scope :with_unread_count, lambda { |worker_id|
    tasks = arel_table
    task_reads = TaskRead.arel_table.alias("tr")
    task_comments = TaskComment.arel_table.alias("tc")

    unread_count = Arel::SelectManager.new
    unread_count.from(task_reads)
    unread_count.project(task_comments[:id].count(true))
    unread_count.join(task_comments, Arel::Nodes::OuterJoin).on(
        task_comments[:task_id].eq(tasks[:id])
          .and(task_comments[:poster_id].not_eq(worker_id))
      )
    unread_count.where(
        task_reads[:task_id].eq(tasks[:id])
          .and(task_reads[:worker_id].eq(worker_id))
          .and(task_reads[:last_read_at].lt(task_comments[:updated_at]))
      )

    select(
      tasks[Arel.star],
      Arel::Nodes::As.new(Arel::Nodes::Grouping.new(unread_count.ast), Arel.sql("unread_count"))
    )
  }

  scope :for_kanban, ->(kanban_column) { where(task_status_id: TaskStatus.kanban_column_ids(kanban_column)) }
  scope :kanban_todo, -> { for_kanban(TaskStatus::KANBAN_TODO) }
  scope :kanban_doing, -> { for_kanban(TaskStatus::KANBAN_DOING) }
  scope :kanban_done, ->(days: 15) { for_kanban(TaskStatus::KANBAN_DONE).where(ended_on: (Time.zone.today - days.days)..) }

  scope :for_gantt, lambda { |start_date, end_date|
    t = arel_table
    gantt_end_on_case =
      Arel::Nodes::Case.new
        .when(
          t[:task_status_id].in(TaskStatus.closed_ids).and(t[:ended_on].not_eq(nil))
        ).then(t[:ended_on])
        .when(
          t[:due_on].not_eq(nil)
        ).then(t[:due_on])
        .when(
          t[:planned_start_on].eq(UNDEFINED_DATE)
        ).then(Arel.sql('CURRENT_DATE'))
        .else(t[:planned_start_on])

    where(t[:planned_start_on].lteq(end_date).and(gantt_end_on_case.gteq(start_date)))
      .where(t[:task_status_id].in(TaskStatus.gantt_ids))
  }

  # ステータス判定メソッド群
  def closed?
    status.closed_flag
  end

  def start?
    status.start_flag
  end

  def started?
    status.started_flag
  end

  def open?
    status.open_flag
  end

  def workable?
    status.work_flag
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
    if closed?
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
        TaskRead.touch_and_get_previous!(task: self, worker_id: new_assignee_id, at: Time.zone.at(0))
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
    if new_status.code == status.code
      errors.add(:status, "が変更されていません")
      raise ActiveRecord::RecordInvalid, self
    end
    if status.next_statuses.pluck(:id).exclude?(new_status.id)
      errors.add(:status, "が不正な値です")
      raise ActiveRecord::RecordInvalid, self
    end

    in_change_tx!(actor: actor, comment: comment) do |c|
      events.create!(
        actor: actor,
        event_type: :change_status,
        status_from_id: task_status_id,
        status_to_id: new_status.id,
        comment: c,
        source: :form
      )
      update_for_start_or_end(new_status, new_params[:end_reason])
      save!
    end
  end

  # 期限変更
  def change_due_on!(new_due_on, actor, comment: nil, source: :form)
    self.comment = comment
    if new_due_on.presence&.to_date == due_on
      errors.add(:due_on, "が変更されていません")
      raise ActiveRecord::RecordInvalid, self
    end
    if closed?
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
    (user.admin? || (creator_id == user.worker_id)) && !closed?
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
    return if office_role_none?

    Worker.for_organization(organization_id).where(office_role: office_role).find_each do |worker|
      task_watchers.find_or_create_by(worker_id: worker.id)
    end
  end

  def add_comment!(actor:, body:)
    comment = comments.create!(poster: actor, body: body)
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
      update!(status: event.status_from)
      event.status_to = nil
      event.status_from = nil
      event.event_type = :add_work
    end
    event.work_id = nil
    event.save!
  end

  def self.add_works!(actor:, check_task_ids:, work:, close_task_ids: [], task_comments: {})
    ActiveRecord::Base.transaction do
      Task.for_organization(work.organization_id).where(id: check_task_ids).find_each do |task|
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
      old_status_id = task_status_id
      old_kanban_column = TaskStatus.find_by(id: old_status_id)&.kanban_column

      if old_kanban_column == new_kanban_column
        update!(kanban_position: new_position)
      else
        new_status = TaskStatus.kanban_status(old_status_id, new_kanban_column)
        self.kanban_position = new_position
        update_for_start_or_end(new_status, :completed)
        save!
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

    if planned_start_on == UNDEFINED_DATE
      Date.current
    else
      planned_start_on
    end
  end

  def gantt_period
    (planned_start_on..gantt_end_on)
  end

  private

  def set_organization
    derived_organization_id = creator&.organization_id || assignee&.organization_id || template&.organization_id
    return if derived_organization_id.blank?

    organization_id_default = self.class.column_defaults['organization_id']
    should_assign_organization =
      organization_id.blank? ||
      (new_record? && organization_id == organization_id_default)

    self.organization_id = derived_organization_id if should_assign_organization
  end

  def members_belong_to_same_organization
    return if organization_id.blank?

    if creator.present? && creator.organization_id != organization_id
      errors.add(:creator_id, "は同じ組織の作業者を選択してください。")
    end
    if assignee.present? && assignee.organization_id != organization_id
      errors.add(:assignee_id, "は同じ組織の作業者を選択してください。")
    end
    if template.present? && template.organization_id != organization_id
      errors.add(:task_template_id, "は同じ組織の定型タスクを選択してください。")
    end
  end

  # rubocop:disable Naming/PredicateMethod
  # 共通ラッパ：コメントを（あれば）作ってトランザクション内でyield
  def in_change_tx!(actor:, comment:)
    transaction do
      created_comment =
        comment.present? ? TaskComment.create!(task: self, poster_id: actor.id, body: comment) : nil
      yield(created_comment)
    end
    true
  end
  # rubocop:enable Naming/PredicateMethod

  def add_work_core!(actor:, work:, close: false, comment: nil)
    task_comment = comment.present? ? comments.create!(poster: actor, body: comment) : nil
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
    return unless closed?

    errors.add(:end_reason, "を選択してください。") if end_reason_unset?
  end

  def clear_end_info
    unless closed?
      self.end_reason = :unset
      self.ended_on = nil
    end
    self.started_on = nil if start?
  end

  def create_watcher
    task_watchers.find_or_create_by(worker_id: assignee_id) if assignee.present?
    task_watchers.find_or_create_by(worker_id: creator_id) if creator.present?
  end

  def create_task_event
    return if creator.nil?

    TaskEvent.create!(
      task: self,
      actor: creator,
      event_type: :task_created,
      source: :form
    )
  end

  def init_task_reads
    return if creator.blank?

    TaskRead.touch_and_get_previous!(task: self, worker_id: creator_id, at: created_at)
    return if assignee.blank? || assignee_id == creator_id

    TaskRead.touch_and_get_previous!(task: self, worker_id: assignee_id, at: Time.at(0))
  end

  def update_for_start_or_end(new_status, end_reason)
    self.task_status_id = new_status.id
    if new_status.started_flag
      self.started_on ||= Time.zone.today
      self.planned_start_on = self.started_on if planned_start_on > self.started_on || planned_start_on == UNDEFINED_DATE
    elsif new_status.closed_flag
      self.ended_on = Time.zone.today
      self.started_on = ended_on if self.started_on.nil? || self.started_on > ended_on
      self.planned_start_on = ended_on if planned_start_on > ended_on
      self.end_reason = end_reason || :other
    end
  end

  def create_planned_start_on
    update(planned_start_on: created_at.to_date)
  end
end
