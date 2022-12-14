class Gaps::TrainingsController < GapsController
  before_action :set_traning, only: [:show, :edit, :update, :destroy]

  def index
    @works = WorkDecorator.decorate_collection(
      Work.by_term(current_term).where(work_kind_id: current_organization.training_id)
      .includes(:work_kind)
    )
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_traning
    @work = Work.find(params[:id])
    @training = @work&.training || Training.new
  end
end
