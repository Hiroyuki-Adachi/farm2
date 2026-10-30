# タスクの担当者を変更し、新しい担当者を閲覧者・未読に加える。
class Task::AssigneeChanger < Task::Changer
  def call!(new_assignee_id, comment: nil)
    @task.comment = comment
    invalid!(:assignee_id, "が変更されていません") if new_assignee_id.to_i == @task.assignee_id.to_i
    invalid!(:assignee_id, "を変更できません（タスクが完了しています）") if @task.closed?

    in_change_tx(comment) do |created_comment|
      @task.events.create!(
        actor: @actor, event_type: :change_assignee,
        assignee_from_id: @task.assignee_id, assignee_to_id: new_assignee_id,
        comment: created_comment
      )
      @task.update!(assignee_id: new_assignee_id)

      if new_assignee_id
        TaskWatcher.find_or_create_by!(task: @task, worker_id: new_assignee_id)
        TaskRead.touch_and_get_previous!(task: @task, worker_id: new_assignee_id, at: Time.zone.at(0))
      end
    end
  end
end
