class WorkResultsController < ApplicationController
  def index
    if params[:fixed_at]
      @results = WorkResult.by_home_for_fix(@term, Date.strptime(params[:fixed_at], '%Y-%m-%d'))
    else
      @results = WorkResult.by_home(@term)
    end

    respond_to do |format|
      format.html do
        @results = WorkResultDecorator.decorate_collection(@results)
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end
end
