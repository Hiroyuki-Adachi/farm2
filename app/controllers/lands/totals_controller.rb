class Lands::TotalsController < ApplicationController
  include PermitChecker

  def index
    @work_kinds = []
    @work_kind_ids = params[:work_kinds].compact_blank! if params[:work_kinds]
    @lands = LandTotalQuery.new(@work_kind_ids, current_system).call unless @work_kind_ids.empty?
  end
end
