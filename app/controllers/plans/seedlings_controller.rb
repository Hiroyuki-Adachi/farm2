class Plans::SeedlingsController < ApplicationController
  include PermitManager

  def new
    @plans = WorkTypePlan.usual
  end

  private

  def menu_name
    return :plan_seedlings
  end
end
