class FixesController < ApplicationController
  before_action :set_fixed_at, only: [:create, :show]
  before_action :set_fix, only: [:destroy]
  before_action :set_show, only: [:create, :show]
  include PermitManager

  MAX_WORKERS = 3
  MAX_SEEDLINGS = 3

  SHOW1_MONTH = 6
  SHOW2_MONTH = 11

  def index
    @making_flag = Delayed::Job.exists?
    @fixes = FixDecorator.decorate_collection(Fix.usual(current_term))
  end

  def show
    case @fixed_at.month
    when SHOW1_MONTH
      @lands = Land.for_finance1.group(:manager_id).sum(:area)
      @seedling_homes = SeedlingHome.usual(current_term)
      render action: :show1
    when SHOW2_MONTH
      @lands1 = Land.for_finance1.group(:manager_id).sum(:area)
      @lands2 = Land.for_finance2.group(:manager_id).sum(:area)
      set_dryings
      render action: :show2
    else
      render action: :show
    end
  end

  def new
    @works = WorkDecorator.decorate_collection(Work.no_fixed(current_term))
    @terms = WorkDecorator.get_terms(current_term)
  end

  def create
    FixWorksJob.perform_later(current_term, params[:fixed_at], current_user.worker_id, params[:fixed_works])
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

  def set_show
    @homes = Home.includes(:workers).for_finance1
    @work_hours = WorkResult.by_works(current_term, @fixed_at)
    @machines = MachineResult.for_fix(current_term, @fixed_at).group(:home_id).sum(:fixed_amount)
    @contracts = WorkLand.for_fix(current_term, @fixed_at, current_organization.contract_work_type_id)
                  .group("lands.manager_id").sum("work_lands.fixed_cost")
  end

  def set_dryings
    @total_dryings = {}
    @waste_totals = {}
    Home.for_drying.each do |home|
      @total_dryings[home.id], @waste_totals[home.id] = Drying.calc_total(
        Drying.by_home(current_term, home), home, current_system
      )
    end
  end
end
