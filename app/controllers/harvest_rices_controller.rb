class HarvestRicesController < ApplicationController
  include PermitManager

  def index
    @dryings = Drying.for_harvest(current_term)
    @work_type_totals, @carried_on_totals = calc_totals(@dryings)
  end

  private

  def calc_totals(dryings)
    work_type_totals = {}
    carried_on_totals = Hash.new { |h, k| h[k] = {}}
    dryings.each do |drying|
      work_type_totals = set_totals1(work_type_totals, drying, drying.work_type_id)
      carried_on_totals = set_totals2(carried_on_totals, drying, drying.work_type_id, drying.carried_on)
    end

    return work_type_totals, carried_on_totals
  end

  def set_totals1(totals, drying, key)
    totals[key] = {
      rice_weight: (totals[key] ? totals[key][:rice_weight] : 0) + (drying.harvest_weight || 0),
      base_weight: (totals[key] ? totals[key][:base_weight] : 0) + (drying&.adjustment&.rice_weight || 0),
      waste_weight: (totals[key] ? totals[key][:waste_weight] : 0) + (drying&.adjustment&.waste_weight || 0)
    }
    return totals
  end

  def set_totals2(totals, drying, key1, key2)
    totals[key1][key2] = {
      rice_weight: (totals[key1][key2] ? totals[key1][key2][:rice_weight] : 0) + (drying.harvest_weight || 0),
      base_weight: (totals[key1][key2] ? totals[key1][key2][:base_weight] : 0) + (drying&.adjustment&.rice_weight || 0),
      waste_weight: (totals[key1][key2] ? totals[key1][key2][:waste_weight] : 0) + (drying&.adjustment&.waste_weight || 0)
    }
    return totals
  end
end
