class OwnedRicesController < ApplicationController
  include PermitManager
  before_action :set_prices, only: [:index, :edit]

  def index
    @homes = Home.for_organization(current_organization).for_owned_rice
    @owned_rices = OwnedRice.usual(current_term, current_organization).to_a
  end

  def edit
    @home = Home.for_organization(current_organization).find(params[:id])
    @p_owned_prices = OwnedRicePrice.usual(previous_term).to_a
    @p_owned_rices = OwnedRice.by_home(previous_term, params[:id], current_organization).to_a
    @owned_rices = OwnedRice.by_home(current_term, params[:id], current_organization).to_a
  end

  def update
    home_ids = owned_rice_home_ids.uniq
    return to_error_path unless Home.for_organization(current_organization).where(id: home_ids).count == home_ids.size

    params.require(:owned_rices).each_value do |v|
      OwnedRice.regist(v[:id], v.permit(:home_id, :owned_rice_price_id, :owned_count), current_organization)
    end
    redirect_to owned_rices_path
  end

  private

  def set_prices
    @owned_prices = OwnedRicePrice.usual(current_term).to_a
  end

  def owned_rice_home_ids
    params.require(:owned_rices).values.filter_map { |v| v[:home_id].presence&.to_i }
  end
end
