class PersonalInformations::TasksController < PersonalInformationsController
  helper MarkdownHelper

  def show
    @task = TaskDecorator.decorate(Task.find(params[:id]))
    @last_read_at = TaskRead.touch_and_get_previous!(task: @task, worker: current_user.worker)
  end
end
