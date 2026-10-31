# タスクと日報の紐づけ・解除。紐づけに合わせてタスクの状態（着手・完了）も進める。
class Task::WorkLinker
  def initialize(task, actor: nil)
    @task = task
    @actor = actor
  end

  # 日報に対して、選択したタスクをまとめて紐づける。既に紐づいているタスクは飛ばす。
  def self.link_all!(actor:, check_task_ids:, work:, close_task_ids: [], task_comments: {})
    Task.transaction do
      Task.for_organization(work.organization_id).where(id: check_task_ids).find_each do |task|
        next if task.events.exists?(work_id: work.id)

        new(task, actor: actor).link!(
          work: work,
          close: close_task_ids.include?(task.id.to_s),
          comment: task_comments[task.id.to_s] || task_comments[task.id]
        )
      end
    end
  end

  def link!(work:, close: false, comment: nil)
    Task.transaction { link_core!(work: work, close: close, comment: comment) }
    @task
  end

  # 紐づけを解除する。紐づけで状態が変わっていて、それが最後のイベントなら状態も戻す。
  def unlink!(work:)
    event = TaskEvent.find_by(task: @task, work: work)
    return if event.nil?

    if event.last? && event.change_status?
      @task.update!(status: event.status_from)
      event.status_to = nil
      event.status_from = nil
      event.event_type = :add_work
    end
    event.work_id = nil
    event.save!
  end

  private

  def link_core!(work:, close:, comment:)
    task_comment = comment.present? ? @task.comments.create!(poster: @actor, body: comment) : nil
    if close
      create_event(:change_status, work, task_comment, status_from: @task.status, status_to: TaskStatus::DONE)
      @task.update!(status: TaskStatus::DONE, started_on: @task.started_on || work.worked_at,
                    ended_on: work.worked_at, end_reason: :completed)
      return
    end
    if @task.status == TaskStatus::DOING
      create_event(:add_work, work, task_comment)
    elsif [TaskStatus::TO_DO, TaskStatus::REOPEN].include?(@task.status)
      create_event(:change_status, work, task_comment, status_from: @task.status, status_to: TaskStatus::DOING)
      @task.update!(status: TaskStatus::DOING, started_on: work.worked_at)
    else
      raise "Cannot add work when task status is #{@task.status.name}"
    end
  end

  def create_event(event_type, work, task_comment, **status_change)
    TaskEvent.create!(task: @task, actor: @actor, event_type: event_type, work: work, comment: task_comment,
                      source: :form, **status_change)
  end
end
