class MachinePricesController < ApplicationController
  include PermitChecker
  before_action :set_machine_price, only: [:index, :edit, :update, :destroy]
  before_action :set_adjusts, only: [:new, :create, :edit, :update]

  def index
    @machine_prices = MachinePriceHeader.histories(@machine_price)
  end

  def show_type
    @machine_type = MachineType.find(params[:machine_type_id])
    @machine_price = MachinePriceHeader.show_type(@machine_type, Time.zone.today).first
  end

  def show_machine
    @machine = Machine.find(params[:machine_id])
    @machine_price = MachinePriceHeader.show_machine(@machine, Time.zone.today).first
  end

  def new
    @machine_price = if params[:machine_id]
                       MachinePriceHeader.new(machine_id: params[:machine_id], machine_type_id: 0, validated_at: Time.zone.today)
                     else
                       MachinePriceHeader.new(machine_type_id: params[:machine_type_id], machine_id: 0, validated_at: Time.zone.today)
                     end
  end

  def create
    @machine_price = MachinePriceHeader.new(machine_price_header_params)
    @machine_price.details_form = params[:details_form]

    if @machine_price.save
      if @machine_price.machine?
        redirect_to show_machine_machine_price_headers_path(machine_id: @machine_price.machine_id)
      else
        redirect_to show_type_machine_price_headers_path(machine_type_id: @machine_price.machine_type_id)
      end
    else
      render action: :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    @machine_price.details_form = params[:details_form]
    if @machine_price.update(machine_price_header_params)
      if @machine_price.machine?
        redirect_to show_machine_machine_price_headers_path(machine_id: @machine_price.machine_id)
      else
        redirect_to show_type_machine_price_headers_path(machine_type_id: @machine_price.machine_type_id)
      end
    else
      render action: :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @machine_price.machine?
      machine_id = @machine_price.machine_id
      @machine_price.destroy
      redirect_to show_machine_machine_price_headers_path(machine_id: machine_id), status: :see_other
    else
      machine_type_id = @machine_price.machine_type_id
      @machine_price.destroy
      redirect_to show_type_machine_price_headers_path(machine_type_id: machine_type_id), status: :see_other
    end
  end

  private

  def set_machine_price
    @machine_price = MachinePriceHeader.find(params[:id])
  end

  def set_adjusts
    @adjusts = Adjust.all
  end

  def machine_price_header_params
    params.expect(machine_price_header: [:validated_at, :machine_id, :machine_type_id])
  end
end
