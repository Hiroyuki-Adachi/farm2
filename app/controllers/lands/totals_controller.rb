class Lands::TotalsController < ApplicationController
  include PermitChecker

  def index
    @work_kind_ids = []
    @work_kind_ids = params[:work_kinds].compact_blank if params[:work_kinds]
    @lands = @work_kind_ids.present? ? LandTotalQuery.new(@work_kind_ids, current_system).call : []

    respond_to do |format|
      format.html
      format.csv do
        send_data render_to_string, filename: "land_totals_#{current_term}.csv", type: 'text/csv; charset=Windows-31J'
      end
    end
  end
end
