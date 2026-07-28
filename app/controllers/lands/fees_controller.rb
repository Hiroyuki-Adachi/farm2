class Lands::FeesController < ApplicationController
  include PermitManager

  def index
    @homes = Home.for_organization(current_organization).for_fee.for_land_select
  end

  def edit
    @home = Home.for_organization(current_organization).find(params[:id])
  end

  def create
    # TODO: 一括作成
  end

  def update
    Home.for_organization(current_organization).find(params[:id])
    LandFee.save_all_from_params(current_organization, params[:id], fee_params)
    redirect_to(lands_fees_path)
  end

  private

  def fee_params
    params.permit(land_fees: [:manage_fee, :peasant_fee, :term, :id, :land_id])[:land_fees]
  end
end
