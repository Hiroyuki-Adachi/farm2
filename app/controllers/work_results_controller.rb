class WorkResultsController < ApplicationController
  def index
    @results = WorkResult.by_home(@term)

    respond_to do |format|
      format.html do
        @results = WorkResultDecorator.decorate_collection(@results)
      end
      format.xml do
        response.headers['Content-type'] = 'application/octet-stream'
      end
    end
  end
end
