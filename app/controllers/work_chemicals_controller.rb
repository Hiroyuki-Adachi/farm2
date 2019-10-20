class WorkChemicalsController < ApplicationController
  include PermitManager

  def index
    @works = WorkDecorator.decorate_collection(Work.by_chemical(@term))
    @chemicals = Chemical.by_work(@term)
    @work_chemicals = {}
    @total_chemicals = {}
    WorkChemical.by_work(@term).each do |wc|
      @work_chemicals["#{wc.work_id},#{wc.chemical_id}"] = wc.quantity
      @total_chemicals[wc.chemical_id] = 0 if @total_chemicals[wc.chemical_id].nil?
      @total_chemicals[wc.chemical_id] += wc.quantity
    end
  end
end
