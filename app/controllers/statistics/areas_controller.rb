class Statistics::AreasController < ApplicationController
  include PermitManager

  helper StatisticsHelper

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
    @selected_work_kind = @work_kinds.find { |work_kind| work_kind.id == @selected_work_kind_id }

    @terms = current_system.get_prev_terms(10).sort
    @area_per_hour =
      if @selected_work_kind_id.present?
        Work.area_per_hour_by_work_kind(
          @selected_work_kind_id,
          @terms,
          organization: current_organization
        )
      else
        @terms.index_with { 0 }
      end

    respond_to do |format|
      format.html
      format.json { render json: chart_data }
    end
  end

  private

  def chart_data
    {
      labels: helpers.labels(@terms.index_with(0), current_organization),
      values: @terms.map { |term| @area_per_hour[term] },
      title: @selected_work_kind&.name
    }
  end

  def menu_name
    :statistics_areas
  end
end
