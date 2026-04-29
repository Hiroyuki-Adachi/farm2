class Statistics::AreasController < ApplicationController
  include PermitManager

  def index
    @work_kinds = WorkKind.aggregatable
    @selected_work_kind_id = params[:work_kind_id].presence&.to_i || @work_kinds.first&.id
  end
end
