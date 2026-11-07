class Lands::StrawsController < ApplicationController
  include PermitManager

  def index
    target_term = params[:term].presence || current_term
    target_system = current_organization.systems.find_by!(term: target_term)
    @straws = LandCost.for_straws(target_system, current_organization.straw_id)
    @work_types = WorkType.for_organization(current_organization).where(id: @straws.keys).usual
  end
end
