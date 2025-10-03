class Works::HealthsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @results = @work.model.work_results
  end

  def create
    WorkResult.regist_health(@work, params.require(:results))
    redirect_to new_work_task_path(work_id: @work.id)
  end
end
