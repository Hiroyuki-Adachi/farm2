class PersonalInformations::StatisticsController < PersonalInformationsController
  def index
    @total_all = Work.total_by_worker(@worker.id, current_term)
  end
end
