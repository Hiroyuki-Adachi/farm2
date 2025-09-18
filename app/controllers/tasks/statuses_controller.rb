class Tasks::StatusesController < TasksController
  before_action :set_task, only: [:edit, :update]
  before_action :set_next_status!, only: [:edit, :update]

  def edit; end

  def update
    @task.change_status!(status_params, current_user.worker)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @task, notice: "タスクの状態を更新しました" }
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_entity
  end

  private

  def status_params
    params.expect(task: [:task_status, :comment, :end_reason])
  end

  def set_next_status!
    @next_status_code = params[:code] || params.dig(:task, :task_status)
  end
end
