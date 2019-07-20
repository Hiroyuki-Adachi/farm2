class SystemsController < ApplicationController
  before_action :permit_admin, only: [:edit, :update]
  before_action :set_system

  def edit
  end

  def update
    if @system.update(system_params)
      redirect_to(menu_index_path)
    else
      render action: :edit
    end
  end

  private

  def set_system
    @system = current_system
  end

  def system_params
    return params.require(:system).permit(
      :start_date,
      :end_date,
      :default_price,
      :default_fee,
      :dry_price,
      :adjust_price,
      :dry_adjust_price
    )
  end
end
