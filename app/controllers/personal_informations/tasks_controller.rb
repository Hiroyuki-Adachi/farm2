class PersonalInformations::TasksController < PersonalInformationsController
  helper MarkdownHelper

  def show
    @task = TaskDecorator.decorate(Task.for_organization(current_user.organization_id).find(params[:id]))
    @last_read_at = TaskRead.touch_and_get_previous!(task: @task.model, worker_id: current_user.worker_id)
  end
end
