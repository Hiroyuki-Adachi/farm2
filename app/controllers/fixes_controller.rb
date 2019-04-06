class FixesController < ApplicationController
  before_action :set_fixed_at, only: [:create, :show]
  before_action :set_fix, only: [:destroy]
  include PermitManager

  MAX_WORKERS = 3
  MAX_SEEDLINGS = 3

  def index
    @fixes = FixDecorator.decorate_collection(Fix.usual(current_term))
  end

  def show
    @homes = Home.includes(:holder).for_finance1
    @lands = Land.for_finance1.group(:manager_id).sum(:area)
    @work_hours = WorkResult.by_works(current_term, @fixed_at)
    @seedling_homes = SeedlingHome.usual(current_term)
    @machines = MachineResult.for_fix(current_term, @fixed_at).group(:home_id).sum(:fixed_amount)
    render action: :show1
  end

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(current_term))
    @terms = WorkDecorator.get_terms(current_term)
  end

  def create
    Fix.do_fix(current_term, @fixed_at, current_user.worker_id, params[:fixed_works])
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
