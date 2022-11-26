class Gaps::CleaningsController < GapsController
  def index
    @works =  WorkDecorator.decorate_collection(Work.by_term(current_term).where(work_kind_id: current_organization.cleaning_id))
  end

  def edit
  end

  def update
  end
end
