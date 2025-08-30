class Lands::TotalsController < ApplicationController
  include PermitChecker

  def index
    @work_kind_ids = []
    @work_kind_ids = params[:work_kinds].compact_blank! if params[:work_kinds]
    @lands = LandTotalQuery.new(@work_kind_ids, current_system).call if @work_kind_ids.present?
  end
end
