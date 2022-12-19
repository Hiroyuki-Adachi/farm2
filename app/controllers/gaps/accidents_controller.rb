class Gaps::AccidentsController < GapsController
  def index
    @accidents = Accident.usual(current_term)
  end

  def show
  end

  def new
  end

  def create
  end

  def edit
  end

  def update
  end

  def destroy
  end
end
