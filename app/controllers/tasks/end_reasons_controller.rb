class Tasks::EndReasonsController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    render :edit, status: :unprocessable_entity and return unless @task.closed?

    if @task.update(end_reason_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "完了理由を更新しました" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def end_reason_params
    params.expect(task: [:end_reason])
  end
end
