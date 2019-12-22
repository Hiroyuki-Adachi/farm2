class OwnedRicesController < ApplicationController
  include PermitManager
  before_action :set_prices, only: [:index, :edit]

  def index
    @homes = Home.for_owned_rice
    @owned_rices = OwnedRice.usual(current_term).to_a
  end

  def edit
    @home = Home.find(params[:id])
    @p_owned_prices = OwnedRicePrice.usual(previous_term).to_a
    @p_owned_rices = OwnedRice.by_home(previous_term, params[:id]).to_a
    @owned_rices = OwnedRice.by_home(current_term, params[:id]).to_a
  end

  def update
    params.require(:owned_rices).each do |_k, v|
      OwnedRice.regist(v[:id], v.permit(:home_id, :owned_rice_price_id, :owned_count))
    end
    redirect_to owned_rices_path
  end

  private

  def set_prices
    @owned_prices = OwnedRicePrice.usual(current_term).to_a
  end
end
