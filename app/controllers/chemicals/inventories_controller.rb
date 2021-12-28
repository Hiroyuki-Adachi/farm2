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
      redirect_to chemicals_inventories_path
    else
      render action: :new
    end
  end

  def edit
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
        stocks_attributes: [:stock, :chemical_id]
      )
      .merge(chemical_adjust_type_id: ChemicalAdjustType::INVENTORY.id)
  end
end
