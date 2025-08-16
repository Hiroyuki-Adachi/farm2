class Chemicals::StoresController < ApplicationController
  include PermitManager
  before_action :set_inventory, only: [:edit, :update, :destroy]

  def index
    @inventories = ChemicalInventory.stores
  end

  def new
    @inventory = ChemicalInventory.new
  end

  def create
    @inventory = ChemicalInventory.new(inventory_params)
    if @inventory.save
      redirect_to edit_chemicals_store_path(@inventory)
    else
      render action: :new, status: :unprocessable_content
    end
  end

  def edit
    @inventory.stocks.build
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to edit_chemicals_store_path(@inventory)
    else
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @inventory.destroy
    redirect_to chemicals_stores_path, status: :see_other
  end

  private

  def set_inventory
    @inventory = ChemicalInventory.find(params[:id])
  end

  def inventory_params
    params
      .require(:chemical_inventory)
      .permit(
        :name,
        :checked_on,
        stocks_attributes: [:stored_stock, :chemical_id, :_destroy, :id]
      )
      .merge(chemical_adjust_type_id: ChemicalAdjustType::STORED.id)
  end
end
