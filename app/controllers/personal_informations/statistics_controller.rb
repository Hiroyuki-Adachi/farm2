class PersonalInformations::StatisticsController < PersonalInformationsController
  def index
    to_error_path unless @worker

    @total_all = Work.total_by_worker(@worker.id, current_term)
  end
end
