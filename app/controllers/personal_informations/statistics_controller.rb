class PersonalInformations::StatisticsController < PersonalInformationsController
  def index
    @total_worker = Work.total_by_worker(@worker, current_term, organization: current_organization)
    @total_home = Work.total_by_home(@worker, current_term, organization: current_organization)
    @total_month1 = Work.total_by_month(@worker, previous_term, organization: current_organization)
    @total_month2 = Work.total_by_month(@worker, current_term, organization: current_organization)
  end
end
