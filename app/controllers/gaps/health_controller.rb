class Gaps::HealthController < GapsController
  def index
    return unless params[:work_type_id]
    @healths, worker_ids = WorkResult.all_health(current_term, params[:work_type_id])
    @workers = Worker.where(id: worker_ids).usual
  end
end
