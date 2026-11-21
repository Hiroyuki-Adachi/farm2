class Works::MachinesController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_results, only: [:new, :create]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @company_machines = Machine.by_work(@work.model).of_company
    @owner_machines = Machine.by_work(@work.model).of_owners(@work.model)
    @lease_machines = Machine.by_work(@work.model).of_no_owners(@work.model).select { |m| m.leasable?(@work.model.worked_at) }
  end

  def create
    unless @work.regist_machines(params[:machine_hours] || {}, params[:machine_amounts] || {})
      new
      render :new, status: :unprocessable_content
      return
    end

    if @work.machine_results.exists?
      redirect_to new_work_remark_path(work_id: @work)
    else
      redirect_to work_path(@work)
    end
  end
end
