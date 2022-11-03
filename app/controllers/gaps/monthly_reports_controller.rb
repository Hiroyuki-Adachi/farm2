class Gaps::MonthlyReportsController < GapsController
  def index
    @work_types = WorkType.land
    @works = []
  end

  def months
    @months = []
    Work.where(work_type_id: params[:id], term: current_term)
     .select("TO_CHAR(worked_at, 'YYYY/MM') AS yyyymm").distinct("yyyymm").order("yyyymm").each do |work|
      yyyy, mm = work.yyyymm.split('/')
      @months << ["#{yyyy}年 #{mm}月", Date.new(yyyy.to_i, mm.to_i, 1)]
    end
    render layout: false, partial: 'months', content_type: 'text/vnd.turbo-stream.html'
  end
end
