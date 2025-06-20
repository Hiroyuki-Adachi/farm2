class Lands::TotalsController < ApplicationController
  include PermitChecker

  def index
    @work_kinds = []
    @work_kinds = params[:work_kinds].compact_blank! if params[:work_kinds]
    @lands = LandTotalQuery.new(@work_kinds, current_system).call unless @work_kinds.empty?
  end
end
