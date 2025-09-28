class PersonalInformations::TasksController < PersonalInformationsController
  helper MarkdownHelper

  def show
    @task = TaskDecorator.decorate(Task.find(params[:id]))
    @last_read_at = TaskRead.touch_and_get_previous!(task: @task, worker_id: current_user.worker_id)
  end
end
