class TotalSeedlingsController < ApplicationController
  include TotalSeedlingsHelper
  include PermitManager

  def index
    @seedling_price = current_system.seedling_price
    @seedling_homes = SeedlingHome.usual(current_term)
    @seedling_result_quantities = SeedlingResult.total(@seedling_homes)

    respond_to do |format|
      format.html
      format.csv {render :content_type => 'text/csv; charset=cp943'}
    end
  end
end
