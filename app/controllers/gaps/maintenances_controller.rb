class Gaps::MaintenancesController < GapsController
  def index
    @works = WorkDecorator.decorate_collection(Work.for_organization(current_organization).by_term(current_term).where(work_kind_id: current_organization.maintenance_id))
  end
end
