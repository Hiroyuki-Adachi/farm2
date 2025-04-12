class Works::ChemicalsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @chemicals = Chemical.usual(@work.model)
  end

  def create
    ActiveRecord::Base.transaction do
      WorkLand.regist_chemical_group_no(params[:work_lands]) if params[:work_lands]
      @work.regist_chemicals(params[:chemicals])
      @work.update(work_params)
    end
    redirect_to work_path(@work)
  end

  private

  def work_params
    params.expect(work: [:chemical_group_flag])
  end
end
