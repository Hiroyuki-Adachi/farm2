class WorkChemicalsController < ApplicationController
  def index
    @works = WorkDecorator.decorate_collection(Work.by_chemical(@term)) 
    @chemicals = Chemical.by_work(@term)
    @work_chemicals = {}
    @total_chemicals = {}
    WorkChemical.by_work(@term).each do |work_chemical|
      @work_chemicals["#{work_chemical.work_id},#{work_chemical.chemical_id}"] = work_chemical.quantity
      @total_chemicals[work_chemical.chemical_id] = @total_chemicals[work_chemical.chemical_id].to_i + work_chemical.quantity
    end
  end
end
