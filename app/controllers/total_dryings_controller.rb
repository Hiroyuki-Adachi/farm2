class TotalDryingsController < ApplicationController
  include PermitManager
  helper DryingsHelper

  def index
    @dryings = {}
    Home.for_drying.each do |home|
      @dryings[home] = DryingDecorator.decorate_collection(Drying.by_home(current_term, home))
    end
    respond_to do |format|
      format.html
      format.csv {render :content_type => 'text/csv; charset=cp943'}
    end
  end
end
