class Works::HealthsController < WorksController
  before_action :set_work, only: [:index]

  def index
    @results = @work.model.work_results
  end

  def menu_name
    return :works
  end
end
