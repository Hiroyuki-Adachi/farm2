class Gaps::MonthlyReportsController < GapsController
  def index
    @months = make_months
    @work_types = WorkType.land
    @works = []
  end
end
