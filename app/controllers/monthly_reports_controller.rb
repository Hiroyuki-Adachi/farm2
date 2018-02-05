class MonthlyReportsController < ApplicationController
  def index
  end

  def show
    @worker = Worker.find(params[:worker_id] || params[:report][:worker_id])
    @target_from =
      if params[:target_from]
        Date.parse(params[:target_from])
      else
        Date.new(params[:report]['target_at(1i)'].to_i, params[:report]['target_at(2i)'].to_i, 1)
      end
    @works = Work.monthly(@term, @target_from, @target_from.end_of_month, @worker.id)
  end

  def edit
    @worker = Worker.find(params[:id])
    @target_from = Date.parse(params[:target_from])
    @works = Work.monthly(@term, @target_from, @target_from.end_of_month, @worker.id)
  end

  def update
    works = params[:data]
    work_kind = WorkKind.where(other_flag: true).first
    Work.transaction do
      works.each do |_, w|
        if w[:check]
          work = Work.find_by_id(w[:id]) || Work.new
          work.term         = @term
          work.worked_at    = Date.strptime(w[:worked_at], "%Y-%m-%d")
          work.weather_id   = w[:weather]
          work.work_type_id = w[:work_type_id]
          work.name         = w[:name]
          work.work_kind_id = work_kind.id
          work.start_at     = DateTime.parse(w[:start_at][:hour]  + ":" + w[:start_at][:minute])
          work.end_at       = DateTime.parse(w[:end_at][:hour]    + ":" + w[:end_at][:minute])
          work.save!

          result = WorkResult.where(work_id: w[:id], worker_id: params[:id]).first || WorkResult.new
          result.work_id    = work.id
          result.worker_id  = params[:id].to_i
          result.hours      = w[:hours]
          result.save!
        else
          Work.destroy_all(w[:id]) unless w[:id].to_i == 0
        end
      end
    end

    redirect_to(monthly_report_path(target_from: works["0"][:worked_at], worker_id: params[:id]))
  end
end
