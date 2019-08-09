class TotalOwnedRicesController < ApplicationController
  include PermitManager

  def index
    @owned_rices = OwnedRice.for_finance(current_term)
    respond_to do |format|
      format.html do
        @home_totals = calc_totals(@owned_rices)
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
      home_totals = set_totals(home_totals, owned_rice, owned_rice.home_id)
    end

    return home_totals
  end

  def set_totals(totals, owned_rice, key)
    totals[key] = {
      owned_count: (totals[key] ? totals[key][:owned_count] : 0) + owned_rice.owned_count,
      relative_count: (totals[key] ? totals[key][:relative_count] : 0) + owned_rice.relative_count,
      owned_price: (totals[key] ? totals[key][:owned_price] : 0) + owned_rice.owned_price,
      relative_price: (totals[key] ? totals[key][:relative_price] : 0) + owned_rice.relative_price,
      sum_count: (totals[key] ? totals[key][:sum_count] : 0) + owned_rice.sum_count,
      sum_price: (totals[key] ? totals[key][:sum_price] : 0) + owned_rice.sum_price
    }
    return totals
  end
end
