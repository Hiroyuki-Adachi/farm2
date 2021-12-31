class Chemicals::InventoriesController < ApplicationController
  include PermitManager
  before_action :set_inventory, only: [:edit, :update, :destroy]

  def index
    @inventories = ChemicalInventory.inventories
  end

  def new
    @inventory = ChemicalInventory.new
  end

  def create
    @inventory = ChemicalInventory.new(inventory_params)
    if @inventory.save
      redirect_to edit_chemicals_inventory_path(@inventory)
    else
      render action: :new
    end
  end

  def edit
    @inventory.stocks.build
  end

  def update
    if @inventory.update(inventory_params)
      redirect_to edit_chemicals_inventory_path(@inventory)
    else
      render action: :edit
    end
  end

  def destroy
    @inventory.destroy
    redirect_to chemicals_inventories_path
  end

  private

  def set_inventory
    @inventory = ChemicalInventory.find(params[:id])
    to_error_path unless @inventory.inventory?
  end

  def inventory_params
    params
      .require(:chemical_inventory)
      .permit(
        :name,
        :checked_on,
        stocks_attributes: [:inventory, :chemical_id, :_destroy, :id]
      )
      .merge(chemical_adjust_type_id: ChemicalAdjustType::INVENTORY.id)
  end
end
