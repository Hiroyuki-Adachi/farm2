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
end
