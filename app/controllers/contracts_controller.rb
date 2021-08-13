class ContractsController < ApplicationController
  include PermitManager

  def index
    @work_lands = work_lands
    @home_totals, @work_totals = calc_totals(@work_lands)
  end

  private

  def work_lands
    work_lands = []
    Work.by_target(current_term).landable.where(work_type_id: current_organization.contract_work_type_id).each do |work|
      work_lands << work.work_lands
    end
    work_lands = work_lands.flatten.sort { |a, b| a.work.worked_at <=> b.work.worked_at}
    return work_lands.sort { |a, b| a.land.manager.display_order <=> b.land.manager.display_order}
  end

  def calc_totals(work_lands)
    home_totals = {}
    work_totals = Hash.new { |h, k| h[k] = {}}
    work_lands.each do |work_land|
      home_totals = set_totals(home_totals, work_land, work_land.land.manager_id)
      work_totals[work_land.land.manager_id] = set_totals(work_totals[work_land.land.manager_id], work_land, work_land.work.id)
    end

    return home_totals, work_totals
  end

  def set_totals(totals, work_land, key)
    totals[key] = {
      area: (totals[key] ? totals[key][:area] : 0) + work_land.land.area,
      cost: (totals[key] ? totals[key][:cost] : 0) + work_land.cost
    }
    return totals
  end
end
