class Gaps::HealthController < GapsController
  def index
    return unless params[:work_type_id]

    @healths, worker_ids = WorkResult.all_health(current_term, params[:work_type_id], current_organization)
    @workers = Worker.for_organization(current_organization).where(id: worker_ids).usual
  end
end
