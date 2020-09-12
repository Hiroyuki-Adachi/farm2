class Plans::SeedlingsController < ApplicationController
  include PermitManager
  before_action :set_info, only: [:new, :index]

  def new
  end

  def create
    PlanSeedling.create_all(params[:seedlings])
    redirect_to plans_seedlings_path
  end

  def index
  end

  private

  def menu_name
    return :plan_seedlings
  end

  def set_info
    @plans = PlanWorkType.usual
    @homes = Home.for_seedling
    @seedlings = PlanSeedling.usual
  end
end
