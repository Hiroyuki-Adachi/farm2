# == Schema Information
#
# Table name: task_events(タスクイベント)
#
#  id                                 :bigint           not null, primary key
#  due_on_from(変更前の期限)          :date
#  due_on_to(変更後の期限)            :date
#  event_type(イベント種別)           :integer          not null
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
  attribute :reader_names, :string, array: true, default: []
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

  after_commit :clear_if_comment_cleared, on: :update
  after_commit :clear_if_work_deleted, on: :update

  scope :usual_order, -> {includes(:actor, :comment).order(created_at: :asc, id: :asc)}

  scope :with_read_info, ->(worker_id, last_read_at) {
    sql = <<-SQL.squish
        #{table_name}.*, 
        COALESCE(
        (SELECT COUNT(DISTINCT tr.worker_id) FROM task_comments tc
          INNER JOIN task_reads tr ON tc.task_id = tr.task_id
            AND tc.updated_at <= tr.last_read_at
            AND tr.worker_id != :worker_id
          WHERE tc.task_id = #{table_name}.task_id
            AND tc.id = #{table_name}.task_comment_id
        ), 0) AS read_count,
        (SELECT ARRAY_AGG(DISTINCT (w.family_name || ' ' || w.first_name))
          FROM task_comments tc
          INNER JOIN task_reads tr ON tc.task_id = tr.task_id
            AND tc.updated_at <= tr.last_read_at
            AND tr.worker_id != :worker_id
          INNER JOIN workers w ON w.id = tr.worker_id
          WHERE tc.task_id = #{table_name}.task_id
            AND tc.id = #{table_name}.task_comment_id
        ) AS reader_names,
        EXISTS(SELECT 1 FROM task_comments tc
            WHERE tc.task_id = #{table_name}.task_id
              AND tc.id = #{table_name}.task_comment_id
              AND tc.poster_id != :worker_id
              AND tc.updated_at > :last_read_at
          ) AS unread_flag,
        (#{table_name}.actor_id = :worker_id) AS mine_flag
      SQL
  
    select(Arel.sql(ApplicationRecord.sanitize_sql_array([sql, {worker_id: worker_id, last_read_at: last_read_at}])))
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
