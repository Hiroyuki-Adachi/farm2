class Works::TasksController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_tasks, only: [:new]

  def new
    redirect_to work_path(@work) and return unless @tasks.exists?
  end

  def create

  end

  private

  def set_tasks
    @tasks = Task.by_work(@work)
  end
end
