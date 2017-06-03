class WorksController < ApplicationController
  before_action :set_work, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :show, :update, :destroy]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :check_fixed, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :update, :destroy]
  before_action :clear_cache, only: [:update, :create, :destroy]

  def index
    @works = Work.usual(@term)
    @sum_hours = Rails.cache.fetch(sum_hours_key(@term), expires_in: 1.hour) do
      WorkResult.where(work_id: @works.ids).group(:work_id).sum(:hours).to_h
    end
    @count_workers = Rails.cache.fetch(count_workers_key(@term), expires_in: 1.hour) do
      WorkResult.where(work_id: @works.ids).group(:work_id).count(:worker_id).to_h
    end
    respond_to do |format|
      format.html do
        @months = WorkDecorator.months(@term)
        if params[:month].blank?
          @month = ""
        else
          @month = params[:month]
          @works = @works.where("date_trunc('month', worked_at) = ?", @month)
        end
        @page = params[:page] || 1
        @works = WorkDecorator.decorate_collection(@works.page(@page))
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
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
    @machines = Machine.by_results(@results)
    @chemicals = @work.work_chemicals
    @results = WorkResultDecorator.decorate_collection(@results)
    render layout: false
  end

  def create
    redirect_to(root_path) if params[:cancel]

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
    @work_kinds = WorkKind.by_type(@work.work_type)
  end

  def edit_workers
    @results = @work.work_results || []
    @sections = Section.usual.pluck(:name, :id).unshift(['すべて', 0])
  end

  def edit_lands
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands) || []
  end

  def edit_machines
    @results = @work.work_results || []
    @company_machines = Machine.by_work(@work.model).of_company
    @owner_machines = Machine.by_work(@work.model).of_owners(@work.model)
    @lease_machines = Machine.by_work(@work.model).of_no_owners(@work.model).select {|m| m.leasable?(@work.model.worked_at) }
  end

  def edit_chemicals
    @chemicals = Chemical.usual(@term, @work.model)
  end

  def update
    redirect_to(work_path(page_params)) if params[:cancel]

    if params[:regist]
      if @work.update(work_params)
        redirect_to(work_path(page_params))
      else
        render action: :edit
      end
    end

    if params[:regist_workers]
      @work.regist_results(params[:results])
      redirect_to(work_path(page_params))
    end

    if params[:regist_lands]
      @work.regist_lands(params[:work_lands] || [])
      redirect_to(work_path(page_params))
    end

    if params[:regist_machines]
      @work.regist_machines(params[:machine_hours] || [])
      redirect_to(work_path(page_params))
    end

    if params[:regist_chemicals]
      @work.regist_chemicals(params[:chemicals])
      redirect_to(work_path(page_params))
    end
  end

  def destroy
    @work.destroy
    redirect_to(works_path(page: params[:page], month: params[:month]))
  end

  def autocomplete_for_land_place
    render json: Land.autocomplete(params[:term])
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
    params.require(:work).permit(:worked_at, :weather_id, :start_at, :end_at, :work_type_id, :work_kind_id, :name, :remarks) 
  end

  def page_params
    params.permit(:page, :month)
  end

  def check_fixed
    redirect_to(works_path(page: params[:page], month: params[:month])) if @work.fixed_at
  end

  def clear_cache
    Rails.cache.clear
  end

  def sum_hours_key(term)
    "sum_hours#{term}"
  end

  def count_workers_key(term)
    "count_workers#{term}"
  end
end
