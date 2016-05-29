class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :show, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]

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
    @work = Work.new(worked_at: Date.today, start_at: '8:00', end_at: '17:00')
    @results = []
    @work_lands = []
    @work_kinds = WorkKind.by_type(@work_types.first)
  end

  def show
    @results = @work.work_results || []
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands || [])
    @organization = Organization.first
    @machines = Machine.by_results(@results)
    @results = WorkResultDecorator.decorate_collection(@results)
  end

  def create
    if params[:cancel]
      redirect_to(root_path)
    end

    if params[:regist]
      @work = Work.new(work_params)
      if @work.save
        redirect_to(work_path(@work.id))
      else
        render action: :new
      end
    end
  end
  
  def work_type_select
    @work_kinds = WorkKind.by_type(WorkType.find(params[:work_type_id]))
    render action: :work_type_select
  end

  def edit
  end

  def edit_workers
    @results = @work.work_results || []
    @sections = Section.usual.pluck(:name, :id).unshift(['すべて', 0])
  end

  def edit_lands
    @work_lands = @work.work_lands || []
    @land_types = LandType.find_lands
  end

  def edit_machines
    @results = @work.work_results || []
  end

  def edit_chemicals
    @chemicals = Chemical.usual(@work.work_kind.chemical_kinds)
  end

  def update
    if params[:cancel]
      redirect_to(work_path(params[:id]))
    end

    if params[:regist]
      if @work.update(work_params)
        redirect_to(work_path(@work.id))
      else
        render action: :edit
      end
    end

    if params[:regist_workers]
      @work.regist_work_results(params[:results])
      redirect_to(work_path(@work.id))
    end

    if params[:regist_lands]
      @work.work_lands = get_params_work_lands
      redirect_to(work_path(@work.id))
    end

    if params[:regist_machines]
      @work.regist_machine_results(params[:machine_hours])
      redirect_to(work_path(@work.id))
    end

    if params[:regist_chemicals]
      @work.regist_work_chemicals(params[:chemicals])
      redirect_to(work_path(@work.id))
    end
  end

  private
  def set_work
    @work = Work.find(params[:id]).decorate
  end
  
  def set_masters
    @weathers = Weather.all
    @work_types = WorkType.usual
  end
  
  def work_params
    return params.require(:work).permit(:worked_at, :weather_id, :start_at, :end_at, :work_type_id, :work_kind_id, :name, :remarks)
  end

  def get_params_work_lands
    work_lands = []

    if params[:work_lands]
      params[:work_lands].each do |param|
        work_lands << WorkLand.new(param)
      end
    end

    return work_lands
  end
end
