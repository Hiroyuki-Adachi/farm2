class Gaps::MaintenancesController < GapsController
  def index
    @works = WorkDecorator.decorate_collection(Work.by_term(current_term).where(work_kind_id: current_organization.maintenance_id))
  end
end
