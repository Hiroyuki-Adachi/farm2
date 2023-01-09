require 'date'

class WorksController < ApplicationController
  include WorksHelper
  protect_from_forgery except: :work_type_select
  before_action :set_work, only: [:edit, :show, :update, :destroy, :map]
  before_action :set_results, only: [:show]
  before_action :set_lands, only: [:show]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :check_fixed, only: [:edit, :update, :destroy]
  before_action :clear_cache, only: [:update, :create, :destroy]
  before_action :permit_not_visitor, except: [:index, :show]
  before_action :permit_checkable_or_self, only: [:edit, :update, :destroy]
  before_action :permit_visitor, only: :show
  before_action :set_term, only: :index
  before_action :set_work_types, only: :index
  before_action :permit_this_term, only: [:edit, :update, :destroy]

  helper GmapHelper

  def index
    @terms = WorkDecorator.terms
    @works = Work.usual(@term)
    @works = @works.by_worker(current_user.worker) if current_user.visitor?
    @sum_hours = sum_hours(@term)
    @count_workers = count_workers(@term)
    set_pager
    respond_to do |format|
      format.html do
        @works = WorkDecorator.decorate_collection(@works.page(@page))
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end

  def new
    @work = Work.new(worked_at: Time.zone.today, work_type_id: @work_types.first.id, start_at: '8:00', end_at: '17:00')
    @results = []
    @work_lands = []
    @work_kinds = WorkKind.by_type(@work_types.first)
  end

  def show
    url_hash = Rails.application.routes.recognize_path(request.referer)

    @machines =  MachineDecorator.decorate_collection(Machine.by_results(@results.object))
    @chemicals = @work.work_chemicals.group(:chemical_id).sum(:quantity).to_a
    @checkers = WorkVerificationDecorator.decorate_collection(@work.work_verifications)

    if ["index", "show"].include?(url_hash[:action])
      session[:work_referer] = url_hash[:controller] == "works" ? nil : request.referer
    end
    render layout: false
  end

  def create
    @work = Work.new(work_params.merge(created_by: current_user.worker.id, term: current_term))
    if @work.save
      redirect_to(new_work_worker_path(work_id: @work))
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit
    @work_kinds = WorkKind.by_type(@work.work_type) || []
  end

  def update
    redirect_to(work_path(@work)) if params[:cancel]

    WorkVerification.regist(@work, current_user.worker)
    if params[:regist]
      if @work.update(work_params)
        @work.refresh_broccoli(current_organization)
      else
        render action: :edit, status: :unprocessable_entity
      end
    end

    redirect_to(work_path(@work))
  end

  def destroy
    @work.destroy
    redirect_to works_path, status: :see_other
  end

  def work_types
    @work_type_id = params[:work_type_id]
    @work_types = params[:term].present? ? WorkType.by_term(params[:term]).indexes : WorkType.indexes
    render layout: false, partial: 'work_types', content_type: 'text/vnd.turbo-stream.html'
  end

  def work_kinds
    @work_kind_id = params[:work_kind_id]
    @work_kinds = params[:work_type_id].present? ? WorkKind.by_type(WorkType.find(params[:work_type_id])) : WorkKind.usual
    render layout: false, partial: 'work_kinds', content_type: 'text/vnd.turbo-stream.html'
  end

  def map
    render layout: false
  end

  private

  def set_work
    @work = Work.find(params[:work_id] || params[:id]).decorate
  end

  def set_results
    @results = WorkResultDecorator.decorate_collection(@work.work_results.includes(:worker) || [])
    @healths = Health.usual
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
    redirect_to works_path if @work.fixed_at
  end

  def clear_cache
    Rails.cache.clear
  end

  def set_pager
    set_search_info
    do_search
    set_session
  end

  def set_term
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == "menu" || session[:work_search].nil?
      @term = current_term
    elsif path[:controller] == "works" && path[:action] == "index"
      @term = params[:term] || current_term
    else
      @term = session[:work_search]["term"] || current_term
    end
  end

  def set_search_info
    path = Rails.application.routes.recognize_path(request.referer)
    if path[:controller] == "menu" || session[:work_search].nil?
      session.delete(:work_search)
      @month = ""
      @work_type_id = ""
      @work_kind_id = ""
      @page = 1
    elsif path[:controller] == "works" && path[:action] == "index" && params[:format] != "csv"
      @work_type_id = params[:work_type_id] || ""
      @work_kind_id = params[:work_kind_id] || ""
      @worked_at1 = params[:worked_at1]
      @worked_at2 = params[:worked_at2]
      @page = params[:page] || 1
    else
      @work_type_id = session[:work_search]["work_type_id"]
      @work_kind_id = session[:work_search]["work_kind_id"]
      @worked_at1 = session[:work_search]["worked_at1"]
      @worked_at2 = session[:work_search]["worked_at2"]
      @page = session[:work_search]["page"] || 1
    end
  end

  def do_search
    @works = @works.where(work_type_id: @work_type_id) if @work_type_id.present?
    @works = @works.where(work_kind_id: @work_kind_id) if @work_kind_id.present?
    @works = @works.where(["worked_at >= ?", @worked_at1]) if @worked_at1.present?
    @works = @works.where(["worked_at <= ?", @worked_at2]) if @worked_at2.present?
    @works_count = @works.count
    @total_hours = @works.inject(0) { |a, e| a + (@sum_hours[e.id] || 0)}
    @total_workers = @works.inject(0) { |a, e| a + (@count_workers[e.id] || 0)}
    @total_hours_member = WorkResult.sum_hours_for_member(@works)
  end

  def set_session
    session[:work_search] = {
      page: @page, work_type_id: @work_type_id, work_kind_id: @work_kind_id,
      worked_at1: @worked_at1, worked_at2: @worked_at2, term: @term
    }
  end

  def set_broccoli
    if broccoli?(@work)
      @sizes = BroccoliSize.usual
      @ranks = BroccoliRank.usual
      @broccoli = @work.broccoli || WorkBroccoli.new
    end
  end

  def set_work_types
    @work_types = WorkType.by_term(@term).indexes
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

  def permit_this_term
    to_error_path unless @work.present? && @work.term == current_term
  end

  def menu_name
    return :works
  end
end
