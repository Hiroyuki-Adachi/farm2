class Tasks::OfficeRolesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    if @task.update(office_role_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "タイトルを更新しました" }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def office_role_params
    params.expect(task: [:office_role])
  end
end
