class OwnedRicePricesController < ApplicationController
  include PermitManager
  before_action :set_owned_rice_price, only: [:edit, :update]

  def index
    @work_types = WorkType.indexes
    @owned_rice_prices = OwnedRicePrice.usual(current_term).to_a
  end

  def edit
  end

  def create
    @owned_rice_price = OwnedRicePrice.new(owned_rice_price_params)
    if @owned_rice_price.save
      redirect_to owned_rice_prices_path
    else
      render action: :edit
    end
  end

  def update
    if @owned_rice_price.update(owned_rice_price_params)
      redirect_to owned_rice_prices_path
    else
      render action: :edit
    end
  end

  def destroy
    OwnedRicePrice.find(params[:id]).destroy
    redirect_to owned_rice_prices_path
  end

  private

  def set_owned_rice_price
    @owned_rice_price = OwnedRicePrice.find_by(term: current_term, work_type_id: params[:id])
    @owned_rice_price ||= OwnedRicePrice.new(term: current_term, work_type_id: params[:id])
  end

  def owned_rice_price_params
    params.require(:owned_rice_price)
          .permit(:term, :work_type_id, :display_order, :name, :short_name, :owned_price, :relative_price)
  end
end
