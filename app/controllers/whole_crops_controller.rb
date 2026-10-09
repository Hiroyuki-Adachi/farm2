class WholeCropsController < ApplicationController
  include PermitManager

  def index
    WorkWholeCrop.update_prices(current_system)
    works = Work.for_organization(current_organization)
      .where(term: current_term, work_kind_id: current_organization.whole_crop_work_kind_id)
    respond_to do |format|
      format.html do
        prepare_list(works)
      end
      format.csv do
        @whole_crops = WholeCropDecorator.decorate_collection(selected_harvests(works))
        send_data render_to_string, filename: "whole_crops_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv", type: :csv
      end
    end
  end

  private

  def prepare_list(works)
    @year_months = works.select("to_char(works.worked_at, 'YYYY-MM')")
      .distinct.order(1).pluck(Arel.sql("to_char(works.worked_at, 'YYYY-MM')"))
    @work_types = WorkType.where(id: works.select(:work_type_id).distinct).order(:display_order, :id)
    rows = works.order(:worked_at, :id).includes(:work_type, whole_crop: [:wcs_lands, :wcs_rolls])
    @works = WorkDecorator.decorate_collection(rows)
  end

  def selected_harvests(works)
    return WorkWholeCrop.none if params[:ids].blank?

    WorkWholeCrop.where(work_id: works.select(:id), id: params[:ids]).usual_order
      .includes(:wcs_lands, :wcs_rolls, work: :work_type).select(&:harvested?)
  end
end
