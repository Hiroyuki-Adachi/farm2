class MachineResultsController < ApplicationController
  def index
    @results = MachineResult.by_home(@term)

    respond_to do |format|
      format.html do
        @results = MachineResultDecorator.decorate_collection(@results)
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end
end
