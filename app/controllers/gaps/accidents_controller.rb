class Gaps::AccidentsController < GapsController
  before_action :set_accident, only: [:show, :edit, :update, :destroy]

  def index
    @accidents = Accident.usual(current_term)
  end

  def show
  end

  def new
    @accident = Accident.new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
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
end
