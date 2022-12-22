class Gaps::AccidentsController < GapsController
  before_action :set_accident, only: [:show, :edit, :update, :destroy]
  helper GmapHelper

  def index
    @accidents = Accident.usual(current_term)
  end

  def show
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

  def edit
  end

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
    render layout: false, partial: 'works', content_type: 'text/vnd.turbo-stream.html'
  end

  def audiences
    @workers = WorkerDecorator.decorate_collection(Work.find(params[:work_id]).workers)
    @worker_id = params[:id]
    render layout: false, partial: 'audiences', content_type: 'text/vnd.turbo-stream.html'
  end

  private

  def set_accident
    @accident = Accident.find(params[:id])
  end

  def accident_params
    params.require(:accident)
          .permit(
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
          )
  end
end
