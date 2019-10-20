class HarvestWholeCropsController < ApplicationController
  include PermitManager

  def index
    @whole_crops = WorkWholeCrop.for_harvest(current_term)
    @work_type_totals, @worked_at_totals = calc_totals(@whole_crops)
    @whole_crops = WholeCropDecorator.decorate_collection(@whole_crops)
  end

  private

  def calc_totals(whole_crops)
    work_type_totals = {}
    month_totals = Hash.new { |h, k| h[k] = {}}
    whole_crops.each do |whole_crop|
      work_type_totals = set_totals1(work_type_totals, whole_crop, whole_crop.work.work_type_id)
      month_totals = set_totals2(
        month_totals,
        whole_crop,
        whole_crop.work.work_type_id,
        whole_crop.work.worked_at.beginning_of_month
      )
    end

    return work_type_totals, month_totals
  end

  def set_totals1(totals, whole_crop, key)
    totals[key] = {
      rolls: (totals[key] ? totals[key][:rolls] : 0) + whole_crop.rolls,
      areas: (totals[key] ? totals[key][:areas] : 0) + whole_crop.work.sum_areas
    }
    return totals
  end

  def set_totals2(totals, whole_crop, key1, key2)
    totals[key1][key2] = {
      rolls: (totals[key1][key2] ? totals[key1][key2][:rolls] : 0) + whole_crop.rolls,
      areas: (totals[key1][key2] ? totals[key1][key2][:areas] : 0) + whole_crop.work.sum_areas
    }
    return totals
  end
end
