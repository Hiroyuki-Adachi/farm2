class WorkResultsController < ApplicationController
  def index
    @results = WorkResult.by_home(@term)

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
