# タスクの期限を変更し、期限変更イベントを記録する。
class Task::DueOnChanger < Task::Changer
  def call!(new_due_on, comment: nil, source: :form)
    @task.comment = comment
    invalid!(:due_on, "が変更されていません") if new_due_on.presence&.to_date == @task.due_on
    invalid!(:due_on, "を変更できません（タスクが完了しています）") if @task.closed?

    in_change_tx(comment) do |created_comment|
      @task.events.create!(
        actor: @actor, event_type: :change_due_on,
        due_on_from: @task.due_on, due_on_to: new_due_on,
        comment: created_comment,
        source: source
      )
      @task.update!(due_on: new_due_on)
    end
  end
end
