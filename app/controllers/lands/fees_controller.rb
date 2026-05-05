class Lands::FeesController < ApplicationController
  include PermitManager

  def index
    @homes = Home.for_fee.landable
  end

  def edit
    @home = Home.find(params[:id])
  end

  def create
    # TODO: 一括作成
  end

  def update
    LandFee.save_all_from_params(params[:id], fee_params)
    redirect_to(lands_fees_path)
  end

  private

  def fee_params
    params.permit(land_fees: [:manage_fee, :peasant_fee, :term, :id, :land_id])[:land_fees]
  end
end
