class Gaps::TrainingsController < GapsController
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
end
