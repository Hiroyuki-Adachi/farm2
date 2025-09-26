class Tasks::WorksController < TasksController
  before_action :set_task
  before_action :set_work, only: :destroy
    
  def destroy
    event = @task.events.find_by(work_id: @work.id)
    return redirect_to task_path(@task) if event.nil? || (event.actor_id != current_user.worker_id)

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
    render turbo_stream: actions
  end

  private
    
  def set_work
    @work = @task.works.find(params[:id])
  end
end
