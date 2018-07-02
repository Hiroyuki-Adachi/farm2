class MachineResultsController < ApplicationController
  include PermitManager

  def index
    if params[:fixed_at]
      @results = MachineResult.by_home_for_fix(@term, Date.strptime(params[:fixed_at], '%Y-%m-%d'))
    else
      @results = MachineResult.by_home(@term).to_a.uniq { |result| [result.work.id, result.machine_id]}
    end
    @owner_totals = calc_totals(@results)

    respond_to do |format|
      format.html do
        @results = MachineResultDecorator.decorate_collection(@results)
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end

  private

  def calc_totals(results)
    owner_totals = {}
    results.each do |result|
      owner_totals = set_totals(owner_totals, result, result.owner.id)
    end

    return owner_totals
  end

  def set_totals(totals, result, key)
    totals[key] = {
      count: (totals[key] ? totals[key][:count] : 0) + 1,
      amount: (totals[key] ? totals[key][:amount] : 0) + result.amount
    }
    return totals
  end
end
