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
      render :edit, status: :unprocessable_content
    end
  end

  private

  def title_params
    params.expect(task: [:title])
  end
end
