class Tasks::WatchersController < TasksController
  before_action :set_task
    
  def create
    @task.task_watchers.create!(worker: current_user.worker)
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("task_watchers", partial: "tasks/watchers/show", locals: { task: @task }) }
      format.html { redirect_to @task, notice: "タスクを監視リストに追加しました。" }
    end
  end
    
  def destroy
    watcher = @task.watching_by(current_user)
    watcher.destroy! if watcher.present?
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.update("task_watchers", partial: "tasks/watchers/show", locals: { task: @task }) }
      format.html { redirect_to @task, notice: "タスクを監視リストから除外しました。" }
    end
  end
end
