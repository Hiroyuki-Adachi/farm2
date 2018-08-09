class WholeCropsController < ApplicationController
  include PermitManager

  def index
    @whole_crops = WorkWholeCrop.usual(current_term)
    respond_to do |format|
      format.html do
        @whole_crops = WholeCropDecorator.decorate_collection(@whole_crops)
      end
      format.csv {render :content_type => 'text/csv; charset=cp943'}
    end
  end

  def create
    params.require(:whole_crop).each do |param|
      WorkWholeCrop.find(param[:id]).update(whole_crop_param(param))
    end
    redirect_to whole_crops_path
  end

  private

  def whole_crop_param(param)
    param.permit(:id, :tax_rate, :unit_price, :article_name)
  end
end

