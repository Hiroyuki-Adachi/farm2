class Chemicals::StoresController < ApplicationController
  include PermitManager
  before_action :set_inventory, only: [:edit, :update, :destroy]

  def index
    @inventories = ChemicalInventory.for_organization(current_organization).stores
  end

  def new
    @inventory = ChemicalInventory.new(organization: current_organization)
  end

  def edit
    @inventory.stocks.build
  end

  def create
    @inventory = ChemicalInventory.new(inventory_params)
    if @inventory.save
      redirect_to edit_chemicals_store_path(@inventory)
    else
      render action: :new, status: :unprocessable_content
    end
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
    @inventory = ChemicalInventory.for_organization(current_organization).find(params[:id])
  end

  def inventory_params
    params
      .require(:chemical_inventory)
      .permit(
        :name,
        :checked_on,
        stocks_attributes: [:stored_stock, :chemical_id, :_destroy, :id]
      )
      .merge(chemical_adjust_type_id: :stored, organization_id: current_organization.id)
  end
end
