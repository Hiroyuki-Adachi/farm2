class WorkChemicalsController < ApplicationController
  include PermitManager

  def index
    @works = WorkDecorator.decorate_collection(Work.by_chemical(@term).includes(:work_kind))
    @chemicals = Chemical.by_term(@term)
    calc_work_chemicals
    respond_to do |format|
      format.html
      format.csv {render :content_type => 'text/csv; charset=cp943'}
    end
  end

  private

  def calc_work_chemicals
    @work_chemicals = {}
    @total_chemicals = {}
    @work_areas = {}
    @work_types = {}
    work_rate_denom = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
    work_rate_numer = Hash.new { |h, k| h[k] = {} }
    work_chemicals_temp = WorkChemical.by_term(@term)
    work_chemicals_temp.each do |work_chemical|
      next if (work_chemical.work.work_lands&.count || 0).zero?
      LandCost.sum_area_by_lands(work_chemical.work.worked_at, work_chemical.work.lands.ids).each do |work_type_id, area|
        chemical_work_type = ChemicalWorkType.by_work_chemical(work_chemical, work_type_id)
        next unless chemical_work_type
        @work_areas["#{work_chemical.work_id},#{work_type_id},#{work_chemical.chemical_id}"] = area
        next if work_rate_denom[work_chemical.work_id][work_chemical.chemical_id][work_type_id].present?
        denom = area * chemical_work_type.quantity
        work_rate_denom[work_chemical.work_id][work_chemical.chemical_id][work_type_id] = denom
        work_rate_numer[work_chemical.work_id][work_chemical.chemical_id] ||= 0
        work_rate_numer[work_chemical.work_id][work_chemical.chemical_id] += denom
      end
      @work_types[work_chemical.work_id] = work_chemical.work.exact_work_types
      @work_types[work_chemical.work_id].each do |work_type|
        numer = work_rate_numer[work_chemical.work_id][work_chemical.chemical_id]
        next if numer.blank?
        work_rate_denom[work_chemical.work_id][work_chemical.chemical_id][work_type.id] = 0 if work_rate_denom[work_chemical.work_id][work_chemical.chemical_id][work_type.id] == {}
        quantity = work_chemical.quantity * work_rate_denom[work_chemical.work_id][work_chemical.chemical_id][work_type.id] / numer
        @work_chemicals["#{work_chemical.work_id},#{work_type.id},#{work_chemical.chemical_id}"] = quantity
        @total_chemicals[work_chemical.chemical_id] ||= 0
        @total_chemicals[work_chemical.chemical_id] += quantity
      end
    end
  end
end
