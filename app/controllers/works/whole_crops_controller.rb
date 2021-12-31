class Works::WholeCropsController < WorksController
  before_action :set_work, only: [:create, :new]

  def new
    @whole_crop = @work.whole_crop || WorkWholeCrop.new
  end

  def create
    WorkWholeCrop.regist(@work, params.require(:whole_crop))
    redirect_to(work_path(@work))
  end
end
