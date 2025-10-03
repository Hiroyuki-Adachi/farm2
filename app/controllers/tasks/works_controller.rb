class Tasks::WorksController < TasksController
  before_action :set_task
  before_action :set_work, only: [:update, :destroy]

  def index
    @works = WorkDecorator.decorate_collection(Work.for_task(@task))
  end

  def update
    begin
      @task.add_work!(actor: current_user.worker, work: @work)
      @task.reload
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "日報を紐づけました" }
      end
    rescue => e
      render :index, status: :unprocessable_content
    end
  end
    
  def destroy
    event = @task.events.find_by(work_id: @work.id)
    return redirect_to task_path(@task), notice: "変更または削除されています。" if event.nil? || (event.actor_id != current_user.worker_id)

    @task.remove_work!(work: @work)

    actions = []

    if @task.events.exists?(work_id: @work.id)
      event.reload
      actions << turbo_stream.update(
        helpers.dom_id(event, :event_item),
        partial: "tasks/events/item",
        locals: { event: event.decorate, mine: true }
      )
    else
      actions << turbo_stream.remove(helpers.dom_id(event, :event_item))
    end
    task = @task.decorate
    actions << turbo_stream.update("task_status_controls", partial: "tasks/statuses/show", locals: { task: task })
    actions << turbo_stream.update("task_status_badge", task.status_badge)
    actions << turbo_stream.update("task_work_link", partial: "tasks/works/link", locals: { task: @task })

    render turbo_stream: actions
  end

  private
    
  def set_work
    @work = Work.find(params[:id])
  end
end
