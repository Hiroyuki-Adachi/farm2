class Gaps::CleaningsController < GapsController
  before_action :set_work, only: [:edit, :update]

  def index
    @works = WorkDecorator.decorate_collection(Work.for_organization(current_organization).by_term(current_term).where(work_kind_id: current_organization.cleaning_id))
  end

  def edit; end

  def update
    @cleaning.attributes = cleaning_params
    if @cleaning.save
      redirect_to gaps_cleanings_path
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  private

  def set_work
    @work = Work.for_organization(current_organization).find(params[:id]).decorate
    @cleaning = @work.model.cleaning || Cleaning.new(work_id: params[:id])
  end

  def cleaning_params
    permitted = params.expect(cleaning:
      [
        :target,
        :method,
        { cleaning_target_ids: [],
          institution_ids: [] }
      ])

    institution_ids = Array(permitted[:institution_ids]).compact_blank.map(&:to_i).uniq
    if Institution.for_organization(current_organization).where(id: institution_ids).count != institution_ids.size
      raise ActiveRecord::RecordNotFound
    end

    permitted[:institution_ids] = institution_ids

    permitted
      .merge(work_id: params[:id])
  end
end
