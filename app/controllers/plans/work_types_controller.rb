class Plans::WorkTypesController < ApplicationController
  include PermitManager

  def new
    @work_types = WorkType.land
  end

  def create
  end

  private

  def menu_name
    return :plan_seedlings
  end
end
