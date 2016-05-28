class WorksController < ApplicationController

 def index
    term = System.first.term
    @months = WorkDecorator.months(term)
    @works = Work.where(term: term).order(worked_at: :DESC, id: :DESC)
    if params[:month].blank?
      @month = ""
    else
      @month = params[:month]
      @works = @works.where("date_trunc('month', worked_at) = ?", @month)
    end

    respond_to do |format|
      format.html do
        @page = params[:page] || 1
        @works = WorkDecorator.decorate_collection(@works.page(@page))
      end
      format.xml do
        response.headers['Content-type'] = 'application/octet-stream'
      end
    end
  end
  
end
