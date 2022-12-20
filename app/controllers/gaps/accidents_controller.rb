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

  private

  def set_accident
    @accident = Accident.find(params[:id])
  end
end
