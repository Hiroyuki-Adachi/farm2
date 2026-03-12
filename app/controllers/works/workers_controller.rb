class Works::WorkersController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_results, only: [:new]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new; end

  def create
    @work.regist_results(params[:results], current_user.worker)
    return redirect_to work_path(@work) if @work.work_results.blank?
    redirect_to new_work_health_path(@work)
  end
end
