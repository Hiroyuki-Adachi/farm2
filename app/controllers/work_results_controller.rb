class WorkResultsController < ApplicationController
  include PermitManager

  def index
    if params[:fixed_at]
      @results = WorkResult.by_home_for_fix(@term, Date.strptime(params[:fixed_at], '%Y-%m-%d'))
    else
      @results = WorkResult.by_home(@term)
    end
    @home_totals, @worker_totals = calc_totals(@results)

    respond_to do |format|
      format.html do
        @results = WorkResultDecorator.decorate_collection(@results)
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end

  private

  def calc_totals(results)
    home_totals = {}
    worker_totals = {}
    results.each do |result|
      home_totals = set_totals(home_totals, result, result.worker.home_id)
      worker_totals = set_totals(worker_totals, result, result.worker.id)
    end

    return home_totals, worker_totals
  end

  def set_totals(totals, result, key)
    totals[key] = {
      count: (totals[key] ? totals[key][:count] : 0) + 1,
      hours: (totals[key] ? totals[key][:hours] : 0) + result.hours,
      amount: (totals[key] ? totals[key][:amount] : 0) + result.amount
    }
    return totals
  end
end
