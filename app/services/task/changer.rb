# タスクの変更（担当者・状態・期限など）の共通処理。
# 変更内容は呼び出し側の task に反映し、エラーも task.errors に積むため、フォームの再表示にそのまま使える。
class Task::Changer
  def initialize(task, actor:)
    @task = task
    @actor = actor
  end

  private

  def invalid!(attribute, message)
    @task.errors.add(attribute, message)
    raise ActiveRecord::RecordInvalid, @task
  end

  # コメントを（あれば）作り、同じトランザクションで変更を行う。
  def in_change_tx(comment)
    @task.transaction do
      created_comment = comment.present? ? TaskComment.create!(task: @task, poster_id: @actor.id, body: comment) : nil
      yield(created_comment)
    end
    @task
  end

  # 着手・完了に伴う着手日・完了日・開始予定日・完了理由を、新しい状態に合わせて設定する（保存はしない）。
  def assign_status(new_status, end_reason)
    @task.task_status_id = new_status.id
    if new_status.started_flag
      assign_started
    elsif new_status.closed_flag
      assign_closed(end_reason)
    end
  end

  def assign_started
    @task.started_on ||= Time.zone.today
    return unless @task.planned_start_on > @task.started_on || @task.planned_start_on == Task::UNDEFINED_DATE

    @task.planned_start_on = @task.started_on
  end

  def assign_closed(end_reason)
    @task.ended_on = Time.zone.today
    @task.started_on = @task.ended_on if @task.started_on.nil? || @task.started_on > @task.ended_on
    @task.planned_start_on = @task.ended_on if @task.planned_start_on > @task.ended_on
    @task.end_reason = end_reason || :other
  end
end
