class Tasks::TitlesController < TasksController
  before_action :set_task, only: [:edit, :update]

  def edit; end

  def update
    if @task.update(title_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @task, notice: "タイトルを更新しました" }
      end
    else
      respond_to do |format|
        format.turbo_stream { render partial: "tasks/titles/form", status: :unprocessable_entity, locals: { task: @task } }
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def title_params
    params.expect(task: [:title])
  end
end
