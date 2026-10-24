# タスクの状態をフォームから変更し、状態変更イベントを記録する。
class Task::StatusChanger < Task::Changer
  def call!(task_status:, end_reason: nil, comment: nil)
    @task.comment = comment
    new_status = TaskStatus.find_by(code: task_status)
    invalid!(:status, "が不正な値です") if new_status.nil?
    invalid!(:status, "が変更されていません") if new_status.code == @task.status.code
    invalid!(:status, "が不正な値です") if @task.status.next_statuses.pluck(:id).exclude?(new_status.id)

    in_change_tx(comment) do |created_comment|
      @task.events.create!(
        actor: @actor,
        event_type: :change_status,
        status_from_id: @task.task_status_id,
        status_to_id: new_status.id,
        comment: created_comment,
        source: :form
      )
      assign_status(new_status, end_reason)
      @task.save!
    end
  end
end
