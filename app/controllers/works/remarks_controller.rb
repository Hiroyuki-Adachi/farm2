class Works::RemarksController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_results, only: [:new]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @remarks = @work.machine_remarks
    @machines = MachineDecorator.decorate_collection(Machine.by_results(@results.object))
  end

  def create
    MachineRemark.regist(@work, params.require(:machine_remarks))
    redirect_to work_path(@work)
  end
end
