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
class TaskEvent < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions

  attribute :read_count, :integer
  attribute :reader_names, :string, array: true, default: -> { [] }
  attribute :unread_flag, :boolean
  attribute :mine_flag, :boolean

  belongs_to :task
  belongs_to :actor, class_name: 'Worker'
  belongs_to :assignee_from, class_name: 'Worker', optional: true
  belongs_to :assignee_to, class_name: 'Worker', optional: true
  belongs_to :comment, class_name: 'TaskComment', foreign_key: 'task_comment_id', optional: true
  belongs_to :work, optional: true
  belongs_to_active_hash :status_from, class_name: 'TaskStatus', foreign_key: 'status_from_id', optional: true
  belongs_to_active_hash :status_to, class_name: 'TaskStatus', foreign_key: 'status_to_id', optional: true

  enum :event_type, { task_created: 0, change_status: 1, change_assignee: 2, change_due_on: 3, add_work: 8, add_comment: 9 }
  enum :source, { form: 0, kanban: 1, gantt: 2, calendar: 3, api: 4, system: 5 }, prefix: true

  after_commit :clear_if_comment_cleared, on: :update
  after_commit :clear_if_work_deleted, on: :update

  scope :usual_order, -> {includes(:actor, :comment).order(created_at: :asc, id: :asc)}
  scope :show_task, -> { where(source: [:form, :gantt, :calendar, :api]) }

  scope :with_read_info, ->(worker_id, last_read_at) {
    task_events = arel_table
    task_comments = TaskComment.arel_table.alias("tc")
    task_reads = TaskRead.arel_table.alias("tr")
    workers = Worker.arel_table.alias("w")

    read_join_condition = task_comments[:task_id].eq(task_reads[:task_id])
      .and(task_comments[:updated_at].lteq(task_reads[:last_read_at]))
      .and(task_reads[:worker_id].not_eq(worker_id))

    read_where_condition = task_comments[:task_id].eq(task_events[:task_id])
      .and(task_comments[:id].eq(task_events[:task_comment_id]))

    read_count = Arel::SelectManager.new
    read_count.from(task_comments)
    read_count.project(task_reads[:worker_id].count(true))
    read_count.join(task_reads).on(read_join_condition)
    read_count.where(read_where_condition)

    reader_name = Arel::Nodes::InfixOperation.new(
      "||",
      Arel::Nodes::InfixOperation.new("||", workers[:family_name], Arel::Nodes.build_quoted(" ")),
      workers[:first_name]
    )

    reader_names = Arel::SelectManager.new
    reader_names.from(task_comments)
    reader_names.project(
      Arel::Nodes::NamedFunction.new("ARRAY_AGG", [Arel::Nodes::Distinct.new(reader_name)])
    )
    reader_names.join(task_reads).on(read_join_condition)
    reader_names.join(workers).on(workers[:id].eq(task_reads[:worker_id]))
    reader_names.where(read_where_condition)

    unread_comments = TaskComment.arel_table.alias("tc")
    unread_query = Arel::SelectManager.new
    unread_query.from(unread_comments)
    unread_query.project(Arel.sql("1"))
    unread_query.where(
        unread_comments[:task_id].eq(task_events[:task_id])
          .and(unread_comments[:id].eq(task_events[:task_comment_id]))
          .and(unread_comments[:poster_id].not_eq(worker_id))
          .and(unread_comments[:updated_at].gt(last_read_at))
      )

    read_count_with_default = Arel::Nodes::NamedFunction.new(
      "COALESCE",
      [read_count, Arel::Nodes.build_quoted(0)]
    )

    select(
      task_events[Arel.star],
      Arel::Nodes::As.new(read_count_with_default, Arel.sql("read_count")),
      Arel::Nodes::As.new(reader_names, Arel.sql("reader_names")),
      Arel::Nodes::As.new(unread_query.exists, Arel.sql("unread_flag")),
      Arel::Nodes::As.new(task_events[:actor_id].eq(worker_id), Arel.sql("mine_flag"))
    )
  }

  def last?
    task.events.order(created_at: :desc, id: :desc).first == self
  end

  private

  def clear_if_comment_cleared
    destroy! if add_comment? && task_comment_id.nil?
  end

  def clear_if_work_deleted
    destroy! if add_work? && work_id.nil?
  end
end
