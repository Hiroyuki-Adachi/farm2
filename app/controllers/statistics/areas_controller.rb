class Statistics::AreasController < ApplicationController
  include PermitManager

  def index
    @work_kinds = WorkKind.aggregatable
    @selected_work_kind_id = params[:work_kind_id].presence&.to_i || @work_kinds.first&.id
    @terms = current_system.get_prev_terms(10).sort
    @hours_per_10a = Work.hours_per_10a_by_work_kind(
      @selected_work_kind_id,
      @terms,
      organization: current_organization
    )
  end
end
