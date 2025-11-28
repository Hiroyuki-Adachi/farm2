class SystemsController < ApplicationController
  before_action :permit_admin, only: [:edit, :update]
  before_action :set_system

  def edit; end

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
    params.expect(system:
      [
        :start_date,
        :end_date,
        :default_price,
        :default_fee,
        :dry_price,
        :adjust_price,
        :dry_adjust_price,
        :half_sum_flag,
        :waste_price,
        :relative_price,
        :waste_drying_price,
        :waste_adjust_price,
        :roll_price
      ])
  end
end
