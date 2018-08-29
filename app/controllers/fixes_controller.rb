class FixesController < ApplicationController
  before_action :set_fixed_at, only: [:create, :show]
  before_action :set_fix, only: [:destroy]
  include PermitManager

  MAX_WORKER = 3

  def index
    @fixes = FixDecorator.decorate_collection(Fix.usual(@term))
  end

  def show
    @homes = Home.includes(:holder).for_finance1
    @lands = Land.for_finance1.group(:manager_id).sum(:area)
    @work_hours, @work_amounts = WorkResult.by_works(@term, @fixed_at)
    render action: :show1
  end

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(@term))
    @terms = WorkDecorator.get_terms(@term)
  end

  def create
    Fix.do_fix(@term, @fixed_at, current_user.worker_id, params[:fixed_works])
    redirect_to fixes_path
  end

  def destroy
    @fix.destroy
    redirect_to fixes_path
  end

  private

  def set_fixed_at
    @fixed_at = Date.strptime(params[:fixed_at], '%Y-%m-%d')
  end

  def set_fix
    @fix = Fix.find([@term, params[:fixed_at]])
  end
end
