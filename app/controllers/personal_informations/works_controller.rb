class PersonalInformations::WorksController < PersonalInformationsController
  before_action :set_work, only: [:show]
  before_action :set_results, only: [:show]
  before_action :set_lands, only: [:show]

  def show
    @machines =  MachineDecorator.decorate_collection(Machine.by_results(@results.object))
    @chemicals = @work.work_chemicals.group(:chemical_id).sum(:quantity).to_a
    @checkers = WorkVerificationDecorator.decorate_collection(@work.work_verifications)
  end

  def set_work
    @work = Work.find(params[:id]).decorate
  end

  def set_results
    @results = WorkResultDecorator.decorate_collection(@work.work_results.includes(:worker) || [])
  end

  def set_lands
    @work_lands = WorkLandDecorator.decorate_collection(@work.work_lands.includes(:land) || [])
  end
end
