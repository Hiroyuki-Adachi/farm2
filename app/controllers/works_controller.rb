require 'date'

class WorksController < ApplicationController
  include WorksHelper
  before_action :set_work, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :show, :update, :destroy, :print]
  before_action :set_results, only: [:show, :edit_workers, :edit_machines]
  before_action :set_lands, only: [:show, :edit_lands]
  before_action :set_broccoli, only: [:show]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :check_fixed, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :update, :destroy]
  before_action :clear_cache, only: [:update, :create, :destroy]
  before_action :permit_not_visitor, except: [:index, :show]
  before_action :permit_checkable_or_self, only: [:edit, :edit_workers, :edit_lands, :edit_machines, :edit_chemicals, :update, :destroy, :print]
  before_action :permit_visitor, only: :show
  before_action :set_work_types, only: :index

  def index
    @works = Work.usual(@term)
    @works = @works.by_worker(current_user.worker) if current_user.visitor?
    @sum_hours = Rails.cache.fetch(sum_hours_key(@term), expires_in: 1.hour) do
      WorkResult.where(work_id: @works.ids).group(:work_id).sum(:hours).to_h
    end
    @count_workers = Rails.cache.fetch(count_workers_key(@term), expires_in: 1.hour) do
      WorkResult.where(work_id: @works.ids).group(:work_id).count(:worker_id).to_h
    end
    if request.xhr?
      set_pager
      respond_to do |format|
        format.js
      end
    else
      respond_to do |format|
        format.html do
          @months = WorkDecorator.months(@term)
          set_pager
        end
        format.csv do
          render :content_type => 'text/csv; charset=cp943'
        end
      end
    end
  end

  def new
    @work = Work.new(worked_at: Date.today, work_type_id: @work_types.first.id, start_at: '8:00', end_at: '17:00')
    @results = []
    @work_lands = []
    @work_kinds = WorkKind.by_type(@work_types.first)
  end

  def show
    @machines =  MachineDecorator.decorate_collection(Machine.by_results(@results.object))
    @chemicals = @work.work_chemicals.group(:chemical_id).sum(:quantity).to_a
    @checkers = WorkVerificationDecorator.decorate_collection(@work.work_verifications)
    session[:work_referer] = Rails.application.routes.recognize_path(request.referer)[:controller] == "works" ? nil : request.referer
    render layout: false
  end

  def create
    @work = Work.new(work_params)
    @work.created_by = current_user.worker.id
    if @work.save
      redirect_to(work_path(@work.id))
    else
      render action: :new
    end
  end

  def work_type_select
    @work_kinds = params[:work_type_id].present? ? WorkKind.by_type(WorkType.find(params[:work_type_id])) : WorkKind.usual
    respond_to do |format|
      format.js { render action: :work_type_select }
    end
  end

  def edit
    @work_kinds = WorkKind.by_type(@work.work_type) || []
  end

  def edit_workers
    @sections = Section.usual.pluck(:name, :id).unshift(['すべて', 0])
  end

  def edit_lands
  end

  def edit_machines
    @company_machines = Machine.by_work(@work.model).of_company
    @owner_machines = Machine.by_work(@work.model).of_owners(@work.model)
    @lease_machines = Machine.by_work(@work.model).of_no_owners(@work.model).select {|m| m.leasable?(@work.model.worked_at) }
  end

  def edit_chemicals
    @chemicals = Chemical.usual(@term, @work.model)
  end

  def update
    redirect_to(work_path(@work)) if params[:cancel]

    WorkVerification.regist(@work, current_user.worker)
    if params[:regist]
      if @work.update(work_params)
        @work.refresh_broccoli(current_organization)
        redirect_to(work_path(@work))
      else
        render action: :edit
      end
    end

    if params[:regist_workers]
      @work.regist_results(params[:results])
      redirect_to(work_path(@work))
    end

    if params[:regist_lands]
      @work.regist_lands(params[:work_lands] || [])
      redirect_to(work_path(@work))
    end

    if params[:regist_machines]
      @work.regist_machines(params[:machine_hours] || [])
      redirect_to(work_path(@work))
    end

    if params[:regist_chemicals]
      @work.regist_chemicals(params[:chemicals])
      redirect_to(work_path(@work))
    end
  end

  def destroy
    @work.destroy
    redirect_to(works_path(page: params[:page], month: params[:month]))
  end

  def autocomplete_for_land_place
    render json: Land.autocomplete(params[:term])
  end

  def print
    @work.update(printed_at: Time.now, printed_by: current_user.worker.id)
    render partial: "show_stamp_print"
  end

  private

  def set_work
    @work = Work.find(params[:id]).decorate
  end

  def set_results
    @results = WorkResultDecorator.decorate_collection(@work.work_results.includes(:worker) || [])
  end

  def set_lands
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands.includes(:land) || [])
  end

  def set_masters
    @weathers = Weather.all
    @work_types = WorkType.usual
  end

  def work_params
    params.require(:work).permit(:worked_at, :weather_id, :start_at, :end_at, :work_type_id, :work_kind_id, :name, :remarks) 
  end

  def check_fixed
    redirect_to(works_path(page: params[:page], month: params[:month])) if @work.fixed_at
  end

  def clear_cache
    Rails.cache.clear
  end

  def set_pager
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == "menu" || session[:work_search].nil?
      session.delete(:work_search)
      @month = ""
      @work_type_id = ""
      @work_kind_id = ""
      @page = 1
    elsif path[:controller] == "works" && path[:action] == "index"
      @month = params[:month] || ""
      @work_type_id = params[:work_type_id] || ""
      @work_kind_id = params[:work_kind_id] || ""
      @page = params[:page].blank? ? 1 : params[:page]
    else
      @month = session[:work_search]["month"]
      @work_type_id = session[:work_search]["work_type_id"]
      @work_kind_id = session[:work_search]["work_kind_id"]
      @page = session[:work_search]["page"] || 1
    end
    @works = @works.where("date_trunc('month', worked_at) = ?", @month) unless @month.blank?
    @works = @works.where(work_type_id: @work_type_id) unless @work_type_id.blank?
    @works = @works.where(work_kind_id: @work_kind_id) unless @work_kind_id.blank?
    @works_count = @works.count
    @total_hours = @works.inject(0) { |a, e| a + (@sum_hours[e.id] || 0) }
    @total_workers = @works.inject(0) { |a, e| a + (@count_workers[e.id] || 0) }
    @works = WorkDecorator.decorate_collection(@works.page(@page))
    session[:work_search] = { month: @month, page: @page, work_type_id: @work_type_id, work_kind_id: @work_kind_id }
  end

  def set_broccoli
    if broccoli?(@work)
      @sizes = BroccoliSize.usual
      @ranks = BroccoliRank.usual
      @broccoli = @work.broccoli || WorkBroccoli.new
    end
  end

  def set_work_types
    @work_types = WorkType.index
    @work_kinds = WorkKind.usual
  end

  def permit_not_visitor
    to_error_path if current_user.visitor?
  end

  def permit_checkable_or_self
    to_error_path unless updatable_work(current_user, @work)
  end

  def permit_visitor
    to_error_path if current_user.visitor? && !@work.work_results.exists?(worker_id: current_user.worker.id)
  end
end
