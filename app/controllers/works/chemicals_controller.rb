class Works::ChemicalsController < WorksController
  before_action :set_work, only: [:new, :create]
  before_action :check_fixed, only: [:new, :create]
  before_action :permit_checkable_or_self, only: [:new, :create]

  def new
    @chemicals = Chemical.usual(@work.model)
  end

  def create
    ActiveRecord::Base.transaction do
      if params[:work_lands]
        Work::ChemicalGroupNoRegistrar.new(@work, params[:work_lands], max_group_no: max_chemical_group_no).call
      end
      @work.regist_chemicals(params[:chemicals])
      @work.update!(work_params)
      Work::ChemicalGroupResetter.new(@work).call
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
    @submitted_group_count = submitted_chemical_group_count
    @chemicals = Chemical.usual(@work.model).to_a
    @chemicals |= Chemical.kept.for_organization(current_organization).where(id: submitted.keys).to_a
  end

  # 画面に表示するグループ数(new.html.erb の group_count)と同じ上限にする
  def max_chemical_group_no
    [@work.work_chemicals.maximum(:chemical_group_no).to_i, current_organization.chemical_group_count.to_i,
     submitted_chemical_group_count].max
  end

  def submitted_chemical_group_count
    (params[:chemicals] || {}).values.flat_map(&:keys).map(&:to_i).max.to_i
  end

  def work_params
    params.expect(work: [:chemical_group_flag])
  end
end
