class PersonalInformations::StatisticsController < PersonalInformationsController
  def index
    @total_all = Work.total_by_worker(@worker.id, current_term)
    @total_month1 = Work.total_by_month(@worker.id, current_term - 1)
    @total_month2 = Work.total_by_month(@worker.id, current_term)
  end
end
