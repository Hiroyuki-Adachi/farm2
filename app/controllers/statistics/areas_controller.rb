class Statistics::AreasController < ApplicationController
  include PermitManager

  def index
    @work_kinds = WorkKind.aggregatable
    allowed_work_kind_ids = @work_kinds.map(&:id)
    requested_work_kind_id = params[:work_kind_id].presence&.to_i
    @selected_work_kind_id =
      if requested_work_kind_id && allowed_work_kind_ids.include?(requested_work_kind_id)
        requested_work_kind_id
      else
        allowed_work_kind_ids.first
      end

    @terms = current_system.get_prev_terms(10).sort
    @hours_per_10a =
      if @selected_work_kind_id.present?
        Work.hours_per_10a_by_work_kind(
          @selected_work_kind_id,
          @terms,
          organization: current_organization
        )
      else
        []
      end
  end

  private

  def menu_name
    return :statistics_areas
  end
end
