class OwnedRicesController < ApplicationController
  def index
    @homes = Home.for_owned_rice
    @owned_prices = OwnedRicePrice.usual(current_term).to_a
    @relative_prices = OwnedRicePrice.relative.usual(current_term).to_a
    @owned_rices = OwnedRice.usual(current_term).to_a
  end

  def edit
  end

  def create
  end

  def update
  end
end
