class TotalOwnedRicesController < ApplicationController
  include PermitManager

  def index
    @owned_rices = OwnedRice.for_finance(current_term)
    respond_to do |format|
      format.html do
        @home_totals = calc_totals(@owned_rices)
        @home_relatives = save_relatives(@home_totals)
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end

  private

  def calc_totals(owned_rices)
    home_totals = {}
    owned_rices.each do |owned_rice|
      home_totals = save_totals(home_totals, owned_rice, owned_rice.home_id)
    end

    return home_totals
  end

  def save_totals(totals, owned_rice, key)
    totals[key] = {
      owned_count: (totals[key] ? totals[key][:owned_count] : 0) + owned_rice.owned_count,
      owned_price: (totals[key] ? totals[key][:owned_price] : 0) + owned_rice.owned_price
    }
    return totals
  end

  def save_relatives(totals)
    results = {}
    totals.each do |k, v|
      if v[:owned_count] > Home.find(k).owned_rice_limit(current_term)
        results[k] = v[:owned_count] - Home.find(k).owned_rice_limit(current_term)
        totals[k][:owned_price] += results[k] * current_system.relative_price
      end
    end
    return results
  end
end
