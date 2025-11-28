class WholeCropsController < ApplicationController
  include PermitManager

  def index
    WorkWholeCrop.update_prices(current_system)
    whole_crops = WorkWholeCrop.usual(current_term)
    respond_to do |format|
      format.html do
        @year_months = whole_crops.select("to_char(works.worked_at, 'YYYY-MM')")
                                  .distinct.order(1).pluck(Arel.sql("to_char(works.worked_at, 'YYYY-MM')"))
        @work_types = WorkType.where(id: whole_crops.pluck('works.work_type_id').uniq).order(:display_order, :id)
        @whole_crops = WholeCropDecorator.decorate_collection(whole_crops.usual_order)
      end
      format.csv do
        @whole_crops = WholeCropDecorator.decorate_collection(whole_crops.where(id: params[:ids]).usual_order)
        send_data render_to_string, filename: "whole_crops_#{Time.current.strftime('%Y%m%d%H%M%S')}.csv", type: :csv
      end
    end
  end
end
