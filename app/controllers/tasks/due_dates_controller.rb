class Tasks::DueDatesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    @task.change_due_on!(new_due_on, current_user.worker, comment: task_comment)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @task, notice: "期限を更新しました" }
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_content
  end

  private

  def new_due_on
    params[:task][:due_on]
  end
end
