class OwnedRicePricesController < ApplicationController
  include PermitManager

  def index
    @work_types = WorkType.indexes
    @owned_rice_prices = OwnedRicePrice.usual(current_term).to_a
  end

  def edit
  end

  def update
  end
end
