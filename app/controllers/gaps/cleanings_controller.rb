class Gaps::CleaningsController < GapsController
  before_action :set_work, only: [:edit, :update]

  def index
    @works = WorkDecorator.decorate_collection(Work.by_term(current_term).where(work_kind_id: current_organization.cleaning_id))
  end

  def edit
  end

  def update
    @cleaning.attributes = cleaning_params
    if @cleaning.save
      redirect_to gaps_cleanings_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  def set_work
    @work = Work.find(params[:id]).decorate
    @cleaning = @work.model.cleaning || Cleaning.new(work_id: params[:id])
  end

  def cleaning_params
    params.require(:cleaning)
          .permit(
            :target, 
            :method,
            :cleaning_flag,
            :animal_flag,
            :pest_flag
          )
          .merge(work_id: params[:id])
  end
end
