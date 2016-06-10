class MachinePricesController < ApplicationController
  before_action :set_machine_price, only: [:index, :edit, :update, :destroy]
  before_action :set_adjusts, only: [:new, :create, :edit, :update]
  
  def index
    @machine_prices = MachinePriceHeader.histories(@machine_price)
  end

  def show_type
    @machine_type = MachineType.find(params[:machine_type_id])
    @machine_price = MachinePriceHeader.show_type(@machine_type, Date.today).first
  end

  def show_machine
    @machine = Machine.find(params[:machine_id])
    @machine_price = MachinePriceHeader.show_machine(@machine, Date.today).first
  end

  def new
    if params[:machine_id]
      @machine_price = MachinePriceHeader.new(machine_id: params[:machine_id], machine_type_id: 0, validated_at: Date.today)
    else
      @machine_price = MachinePriceHeader.new(machine_type_id: params[:machine_type_id], machine_id: 0, validated_at: Date.today)
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
      render action: :new
    end
  end
  
  def edit
  end
  
  def update
    @machine_price.details_form = params[:details_form]
    if @machine_price.update(machine_price_header_params)
      if @machine_price.machine?
        redirect_to show_machine_machine_price_headers_path(machine_id: @machine_price.machine_id)
      else
        redirect_to show_type_machine_price_headers_path(machine_type_id: @machine_price.machine_type_id)
      end
    else
      render action: :edit
    end
  end

  def destroy
    if @machine_price.machine?
      machine_id =  @machine_price.machine_id
      @machine_price.destroy
      redirect_to show_machine_machine_price_headers_path(machine_id: machine_id)
    else
      machine_type_id =  @machine_price.machine_type_id
      @machine_price.destroy
      redirect_to show_type_machine_price_headers_path(machine_type_id: machine_type_id)
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
    return params.require(:machine_price_header).permit(:validated_at, :machine_id, :machine_type_id)
  end

end
