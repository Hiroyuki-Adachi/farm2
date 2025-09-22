class Tasks::AssigneesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    @task.change_assignee!(new_assignee_id, current_user.worker, task_comment)
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to @task, notice: "担当者を更新しました" }
    end
  rescue ActiveRecord::RecordInvalid
    render :edit, status: :unprocessable_content
  end

  private

  def new_assignee_id
    params[:task][:assignee_id]
  end
end
