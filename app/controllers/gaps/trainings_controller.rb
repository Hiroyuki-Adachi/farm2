class Gaps::TrainingsController < GapsController
  before_action :set_traning, only: [:show, :edit, :update, :destroy]

  def index
    @works = WorkDecorator.decorate_collection(
      Work.by_term(current_term).where(work_kind_id: current_organization.training_id).includes(:training, :workers)
      .includes(:work_kind)
    )
  end

  def show
  end

  def edit
  end

  def update
    @training.attributes = traning_params
    if @training.save
      redirect_to gaps_trainings_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
  end

  private

  def set_traning
    @work = Work.find(params[:id]).decorate
    @training = @work&.training || Training.new
    @schedules = Schedule.for_training(@work)
  end

  def traning_params
    params.require(:training)
          .permit(
            :schedule_id,
            :worker_id,
            :content,
            :document,
            :training_place,
            :studying_place,
            :remarks,
          )
          .merge(work_id: params[:id])
  end
end
