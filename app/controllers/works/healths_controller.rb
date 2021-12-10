class Works::HealthsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @results = @work.model.work_results
  end

  def create
    binding.pry
    WorkResult.regist_health(@work, params[:results])
  end

  def menu_name
    return :works
  end
end
