class WorkSeedlingsController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.land
    @work_seedlings, @work_areas = calc_seedlings(Work.where(work_kind_id: current_organization.rice_planting_id).by_term(@term))

    respond_to do |format|
      format.html do
      end
      format.csv do
        render :content_type => 'text/csv; charset=cp943'
      end
    end
  end

  private

  def calc_seedlings(works)
    work_seedlings = Hash.new { |h, k| h[k] = {} }
    work_areas = Hash.new { |h, k| h[k] = {} }
    works.each do |work|
      LandCost.sum_area_by_lands(work.worked_at, work.lands.ids).each do |work_type_id, area|
        work_seedlings[work_type_id][work.id] = work.sum_seedlings(work_type_id)
        work_areas[work_type_id][work.id] = area
      end
    end
    return work_seedlings, work_areas
  end
end
