class Gaps::LandTermMarksController < GapsController
  before_action :set_land_term_mark, only: [:update, :destroy]

  def index
    @land_term_marks = land_term_marks.usual
    @land_term_mark = LandTermMark.new(term: current_term)
  end

  def create
    @land_term_mark = LandTermMark.new(land_term_mark_params.merge(term: current_term))

    @land_term_mark.errors.add(:land_id, :invalid) unless managed_land?(@land_term_mark.land_id)

    if @land_term_mark.errors.blank? && @land_term_mark.save
      redirect_to gaps_land_term_marks_path, status: :see_other
    else
      @land_term_marks = land_term_marks.usual
      render :index, status: :unprocessable_content
    end
  end

  def update
    if @land_term_mark.update(mark: land_term_mark_params[:mark])
      redirect_to gaps_land_term_marks_path, status: :see_other
    else
      @error_land_term_mark = @land_term_mark
      @land_term_mark = LandTermMark.new(term: current_term)
      @land_term_marks = land_term_marks.usual
      render :index, status: :unprocessable_content
    end
  end

  def destroy
    @land_term_mark.destroy
    redirect_to gaps_land_term_marks_path, status: :see_other
  end

  def autocomplete
    render json: Land.to_autocomplete(candidate_lands.includes(:owner))
  end

  private

  def land_term_marks
    LandTermMark.for_organization(current_organization).by_term(current_term)
  end

  def candidate_lands
    Land.for_organization(current_organization).usual.expiry(Time.zone.today).where(group_flag: false)
  end

  def set_land_term_mark
    @land_term_mark = land_term_marks.find(params[:id])
  end

  def managed_land?(land_id)
    candidate_lands.exists?(id: land_id)
  end

  def land_term_mark_params
    params.expect(land_term_mark: [:land_id, :mark])
  end
end
