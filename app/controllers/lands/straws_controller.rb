class Lands::StrawsController < ApplicationController
  include PermitManager

  def index
    @straws = LandCost.for_straws(params[:term] || current_term, current_organization.straw_id, current_organization)
    @work_types = WorkType.where(id: @straws.keys).usual
  end
end
