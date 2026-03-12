require 'date'

class WorksController < ApplicationController
  include UpdatableWork

  before_action :set_work, only: [:edit, :show, :update, :destroy, :map]
  before_action :set_results, only: [:show]
  before_action :set_lands, only: [:show]
  before_action :set_masters, only: [:new, :create, :edit, :update]
  before_action :check_fixed, only: [:edit, :update, :destroy]
  before_action :clear_cache, only: [:update, :create, :destroy]
  before_action :permit_not_visitor, except: [:index, :show]
  before_action :permit_checkable_or_self, only: [:edit, :update, :destroy]
  before_action :permit_visitor, only: :show
  before_action :permit_this_term, only: [:edit, :update, :destroy]

  helper WorksHelper
  helper GmapHelper

  def index
    @terms = WorkDecorator.terms

    # term は params 優先。なければ current_term
    @term = params[:term].presence || current_term

    # term でベースを絞る
    base = Work.usual(@term)
    base = base.by_worker(current_user.worker) if current_user.visitor?

    # 検索条件（ビューでフォームの初期値にも使う）
    @work_search = {
      work_type_id: params[:work_type_id],
      work_kind_id: params[:work_kind_id],
      worked_at1: params[:worked_at1],
      worked_at2: params[:worked_at2],
      except: params[:except]
    }

    # 検索実行
    @works = Work.search_for_work(base, @work_search)

    # 集計もここで
    @sum_hours     = sum_hours(@term)
    @count_workers = count_workers(@term)
    @works_count   = @works.count
    @total_hours   = @works.joins(:work_results).sum('work_results.hours')
    @total_workers = @works.joins(:work_results).distinct.count('work_results.worker_id')
    @total_hours_member = WorkResult.sum_hours_for_member(@works)

    set_work_types # （この中で @work_types, @work_kinds をセットする今のメソッド）

    respond_to do |format|
      format.html do
        @works = WorkDecorator.decorate_collection(@works.page(params[:page]))
      end
      format.csv do
        render content_type: 'text/csv; charset=cp943'
      end
    end
  end

  def new
    @work = Work.new(
      worked_at: Time.zone.today,
      work_type_id: @work_types.first.id,
      weather_id: :sunny,
      start_at: '8:00', end_at: '17:00'
    )
    @results = []
    @work_lands = []
    @work_kinds = WorkKind.except_other.by_type(@work_types.first)
  end

  def show
    @machines =  MachineDecorator.decorate_collection(Machine.by_results(@results.object))
    @chemicals = Chemical.with_total_quantity(@work).to_a
    @checkers = WorkVerificationDecorator.decorate_collection(@work.work_verifications)

    render layout: false
  end

  def create
    @work = Work.new(work_params.merge(created_by: current_user.worker.id, term: current_term))
    if @work.save
      redirect_to(new_work_worker_path(work_id: @work))
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def edit
    @work_kinds = WorkKind.except_other.by_type(@work.work_type) || []
  end

  def update
    redirect_to(work_path(@work)) if params[:cancel]

    WorkVerification.regist(@work, current_user.worker)
    if params[:regist]
      if @work.update(work_params)
        @work.refresh_broccoli(current_organization)
      else
        render action: :edit, status: :unprocessable_content and return
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
    respond_to { |format| format.turbo_stream }
  end

  def work_kinds
    @work_kind_id = params[:work_kind_id]
    @work_kinds = params[:work_type_id].present? ? WorkKind.except_other.by_type(WorkType.find(params[:work_type_id])) : WorkKind.usual
    respond_to { |format| format.turbo_stream }
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
    @work_types = WorkType.usual.by_term(current_term)
  end

  def work_params
    params.expect(work: [:worked_at, :weather_id, :start_at, :end_at, :work_type_id, :work_kind_id, :name, :remarks])
  end

  def check_fixed
    redirect_to works_path if @work.fixed_at
  end

  def clear_cache
    Rails.cache.clear
  end

  def set_work_types
    @work_types = WorkType.by_term(@term).indexes
    @work_kinds = WorkKind.usual
  end

  def permit_not_visitor
    to_error_path if current_user.visitor?
  end

  def permit_checkable_or_self
    to_error_path unless updatable_work?(@work)
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
