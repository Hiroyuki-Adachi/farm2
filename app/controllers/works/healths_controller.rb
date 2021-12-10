class Works::HealthsController < WorksController
  before_action :set_work, only: [:index, :create]

  def index
    @results = @work.model.work_results
  end

  def create
  end

  def menu_name
    return :works
  end
end
