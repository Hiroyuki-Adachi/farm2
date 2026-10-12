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
      @work.update!(work_params)
    end
    redirect_to work_path(@work)
  rescue ActiveRecord::RecordInvalid => e
    prepare_invalid_form(e.record)
    render :new, status: :unprocessable_content
  end

  private

  def prepare_invalid_form(record)
    @work.errors.add(:base, record.errors.full_messages.join('、')) unless record == @work
    submitted = params[:chemicals] || {}
    @submitted_group_count = submitted.values.flat_map(&:keys).map(&:to_i).max
    @chemicals = Chemical.usual(@work.model).to_a
    @chemicals |= Chemical.kept.for_organization(current_organization).where(id: submitted.keys).to_a
  end

  def work_params
    params.expect(work: [:chemical_group_flag])
  end
end
