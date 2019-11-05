class TotalChemicalsController < ApplicationController
  include PermitManager

  def index
    work_kind = current_organization.rice_planting
    @chemical_types = work_kind.chemical_types
    @works = Work.usual(current_term).where(work_kind_id: work_kind)
  end
end
