class Tasks::PrioritiesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    if @task.update(priority_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "優先度を更新しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/priorities/form", status: :unprocessable_entity, locals: { task: @task } }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def priority_params
    params.expect(task: [:priority])
  end
end
