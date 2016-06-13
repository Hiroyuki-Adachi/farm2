class MachineResultsController < ApplicationController
  def index
    if params[:fixed_at]
      @results = MachineResult.by_home_for_fix(@term, Date.strptime(params[:fixed_at], '%Y-%m-%d'))
    else
      @results = MachineResult.by_home(@term).to_a.uniq{|result| [result.work.id, result.machine_id]}
    end

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
