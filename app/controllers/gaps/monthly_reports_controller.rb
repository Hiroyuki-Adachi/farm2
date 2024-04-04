class Gaps::MonthlyReportsController < GapsController
  def index
    @works = WorkDecorator.decorate_collection(Work.monthly_reports(params[:work_type_id], params[:worked_at].to_date)) if params[:work_type_id].present? && params[:worked_at].present?
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
