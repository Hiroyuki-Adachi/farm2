class Gaps::HarvestsController < GapsController
  def index
    if params[:work_type_id].present? && params[:worked_at].present?
      @works = WorkDecorator.decorate_collection(harvest_works(params.expect(:work_type_id), params.expect(:worked_at).to_date))
    end
  end

  def months
    @months = []
    harvest_base(params[:id])
      .select("TO_CHAR(worked_at, 'YYYY/MM') AS yyyymm")
      .distinct("yyyymm")
      .order("yyyymm")
      .each do |work|
        yyyy, mm = work.yyyymm.split("/")
        @months << ["#{yyyy}年 #{mm}月", Date.new(yyyy.to_i, mm.to_i, 1)]
      end
    render layout: false, partial: "gaps/monthly_reports/months", content_type: "text/vnd.turbo-stream.html"
  end

  private

  def harvest_base(work_type_id)
    Work.for_organization(current_organization)
      .where(term: current_term)
      .where(work_type_id: work_type_id)
      .where(work_kind_id: current_organization.broccoli_work_kind_id)
  end

  def harvest_works(work_type_id, worked_at)
    harvest_base(work_type_id)
      .where(worked_at: Date.new(worked_at.year, worked_at.month, 1)..Date.new(worked_at.year, worked_at.month, -1))
      .includes(:work_kind, :work_type, lands: :land_term_marks)
      .order(worked_at: :ASC, start_at: :ASC, id: :ASC)
  end
end
