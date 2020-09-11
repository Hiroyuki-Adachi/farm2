class Plans::SeedlingsController < ApplicationController
  include PermitManager

  def new
    @plans = PlanWorkType.usual
  end

  private

  def menu_name
    return :plan_seedlings
  end
end
