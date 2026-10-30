class Tasks::DueDatesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    Task::DueOnChanger.new(@task, actor: current_user.worker).call!(new_due_on, comment: task_comment)
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
