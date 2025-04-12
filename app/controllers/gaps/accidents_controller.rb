class Gaps::AccidentsController < GapsController
  before_action :set_accident, only: [:show, :edit, :update, :destroy]
  helper GmapHelper

  def index
    @accidents = Accident.usual(current_term)
  end

  def show
    @accident = @accident.decorate
  end

  def new
    @accident = Accident.new(accident_type_id: AccidentType::RULE.id)
  end

  def create
    @accident = Accident.new(accident_params)
    if @accident.save
      redirect_to gaps_accidents_path
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @accident.update(accident_params)
      redirect_to gaps_accidents_path
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @accident.destroy
    redirect_to gaps_accidents_path, status: :see_other
  end

  def works
    @works = WorkDecorator.decorate_collection(Work.usual(current_term).where(worked_at: params[:worked_at]))
    @work_id = params[:id]
    respond_to { |format| format.turbo_stream }
  end

  def audiences
    return if params[:work_id].blank?
    @workers = WorkerDecorator.decorate_collection(Work.find(params[:work_id]).workers)
    @worker_id = params[:id]
    respond_to { |format| format.turbo_stream }
  end

  private

  def set_accident
    @accident = Accident.find(params[:id])
    @works = WorkDecorator.decorate_collection(Work.usual(@accident.work.term).where(worked_at: @accident.work.worked_at))
    @workers = WorkerDecorator.decorate_collection(@accident.work.workers)
  end

  def accident_params
    params.expect(accident:
      [
        :investigator_id,
        :investigated_on,
        :informant_name,
        :accident_type_id,
        :work_id,
        :audience_id,
        :location,
        :location_name,
        :content,
        :problem,
        :solving,
        :result
      ])
  end
end
