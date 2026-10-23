# タスクの作成と、作成時に必要な閲覧者・作成イベント・既読の登録を同じトランザクションで行う。
class TaskCreator
  def initialize(task)
    @task = task
  end

  # 保存できなければ false を返す。
  def call
    Task.transaction do
      assign_planned_start_on
      saved = @task.save
      create_associations if saved
      saved
    end
  end

  # 保存できなければ例外を出す。作成したタスクを返す。
  def call!
    Task.transaction do
      assign_planned_start_on
      @task.save!
      create_associations
    end
    @task
  end

  private

  # 開始予定日は入力値によらず作成日にする。作成直後の UPDATE を避けるため INSERT 前に設定する。
  # 完了状態で作成日より前の完了日があれば、状態変更時と同じく完了日に合わせる。
  def assign_planned_start_on
    @task.created_at ||= Time.current
    ended_on = @task.ended_on if @task.closed?
    @task.planned_start_on = [@task.created_at.to_date, ended_on].compact.min
  end

  def create_associations
    create_watchers
    create_task_event
    init_task_reads
  end

  def create_watchers
    @task.task_watchers.find_or_create_by!(worker_id: @task.assignee_id) if @task.assignee.present?
    @task.task_watchers.find_or_create_by!(worker_id: @task.creator_id) if @task.creator.present?
  end

  def create_task_event
    return if @task.creator.nil?

    TaskEvent.create!(task: @task, actor: @task.creator, event_type: :task_created, source: :form)
  end

  def init_task_reads
    return if @task.creator.blank?

    TaskRead.touch_and_get_previous!(task: @task, worker_id: @task.creator_id, at: @task.created_at)
    return if @task.assignee.blank? || @task.assignee_id == @task.creator_id

    TaskRead.touch_and_get_previous!(task: @task, worker_id: @task.assignee_id, at: Time.zone.at(0))
  end
end
