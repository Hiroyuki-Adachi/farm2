class Plans::WorkTypesController < ApplicationController
  include PermitManager

  def new
    @work_types = WorkType.land
  end

  def create
  end
end
