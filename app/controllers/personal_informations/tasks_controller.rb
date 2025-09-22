class PersonalInformations::TasksController < PersonalInformationsController
  helper MarkdownHelper

  def show
    @task = TaskDecorator.decorate(Task.find(params[:id]))
  end
end
