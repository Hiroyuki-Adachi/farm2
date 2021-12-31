class Works::ChemicalsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @chemicals = Chemical.usual(@work.model)
  end

  def create
    @work.regist_chemicals(params[:chemicals])
    redirect_to work_path(@work)
  end
end
