class Works::SupportersController < ApplicationController
  include PermitManager

  def index
    @results = WorkResultDecorator.decorate_collection(WorkResult.by_supporter_home(current_term))
    @home_totals, @month_totals = calc_totals(@results)
  end

  private

  def calc_totals(results)
    home_totals = {}
    month_totals = {}
    results.each do |result|
      month_totals = set_totals(month_totals, result, month_code(result))
      home_totals = set_totals(home_totals, result, home_code(result))
    end

    [home_totals, month_totals]
  end

  def set_totals(totals, result, key)
    totals[key] = {
      count: (totals[key] ? totals[key][:count] : 0) + 1,
      hours: (totals[key] ? totals[key][:hours] : 0) + result.object.hours,
      amount: (totals[key] ? totals[key][:amount] : 0) + result.object.amount
    }
    totals
  end

  def month_code(result)
    worked_at = result.object.work.worked_at.to_date
    worked_at.strftime('%Y%m')
  end

  def home_code(result)
    "#{month_code(result)}_#{result.worker.home_id}"
  end
end
