class Works::LandsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :set_lands, only: [:new]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
  end

  def create
    @work.regist_lands(params[:work_lands] || [])
    redirect_to(work_path(@work))
  end
end
