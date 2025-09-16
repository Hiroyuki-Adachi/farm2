class Tasks::DescriptionsController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    if @task.update(task_params)
      respond_to do |format|
        format.turbo_stream # update.turbo_stream.erb でフレーム置換
        format.html { redirect_to @task, notice: "説明を更新しました。" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render :edit, status: :unprocessable_entity }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def task_params
    params.expect(task: [:description])
  end
end
