class Works::TasksController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_tasks, only: [:new]

  decorates_assigned :tasks, with: TaskDecorator

  def new
    redirect_to work_path(@work) and return unless @tasks.exists?
    @tasks = @tasks.usual_order
  end

  def create
    logger.debug "params: #{params.inspect}"
    Task.add_works!(
      actor: current_user.worker,
      check_task_ids: params[:check_task_ids] || [],
      close_task_ids: params[:close_task_ids] || [],
      task_comments: params[:task_comments] || {},
      work: @work
    )
    redirect_to work_path(@work)
  end

  private

  def set_tasks
    @tasks = Task.for_work(@work)
  end
end
