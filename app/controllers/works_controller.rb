class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :show, :update, :destroy]

 def index
    term = System.first.term
    @months = WorkDecorator.months(term)
    @works = Work.where(term: term).order(worked_at: :DESC, id: :DESC)
    if params[:month].blank?
      @month = ""
    else
      @month = params[:month]
      @works = @works.where("date_trunc('month', worked_at) = ?", @month)
    end

    respond_to do |format|
      format.html do
        @page = params[:page] || 1
        @works = WorkDecorator.decorate_collection(@works.page(@page))
      end
      format.xml do
        response.headers['Content-type'] = 'application/octet-stream'
      end
    end
  end

  def new
    @work = Work.new(:start_at => '8:00', :end_at => '17:00')
    @results = []
    @work_lands = []
  end

  def show
    @results = @work.work_results || []
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands || [])
    @organization = Organization.first
    @machines = Machine.by_results(@results)
    @results = WorkResultDecorator.decorate_collection(@results)
  end

  private
  def set_work
    @work = Work.find(params[:id]).decorate
  end
end
