class Tasks::DueDatesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    if @task.change_due_on!(new_due_on, current_user.worker, task_comment)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "期限を更新しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/due_dates/form", status: :unprocessable_entity, locals: { task: @task } }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def new_due_on
    params[:task][:due_on]
  end
end
