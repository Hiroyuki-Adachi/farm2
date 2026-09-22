class MachineReserveFundsController < ApplicationController
  include PermitManager
  include ReturnToIndex

  before_action :set_machine_reserve_fund, only: [:edit, :update, :destroy]
  before_action :set_machine_types, only: [:new, :create, :edit, :update]
  keeps_index_return_to path_method: :machine_reserve_funds_path

  def index
    @machine_reserve_funds =
      MachineReserveFund.for_organization(current_organization).includes(machine: :machine_type).usual
  end

  def new
    @machine_reserve_fund = MachineReserveFund.new(years: 7)
    @selected_machine_type_id = params[:machine_type_id]
    @machines = machines_for(@selected_machine_type_id)
  end

  def edit
    @selected_machine_type_id = @machine_reserve_fund.machine.machine_type_id
    @machines = machines_for(@selected_machine_type_id)
  end

  def create
    @machine_reserve_fund = MachineReserveFund.new(
      machine_reserve_fund_params.merge(organization: current_organization)
    )

    if @machine_reserve_fund.save
      redirect_to machine_reserve_funds_path
    else
      @selected_machine_type_id = params[:machine_type_id]
      @machines = machines_for(@selected_machine_type_id)
      render action: :new, status: :unprocessable_content
    end
  end

  def update
    if @machine_reserve_fund.update(machine_reserve_fund_params)
      redirect_to @return_to
    else
      @selected_machine_type_id = params[:machine_type_id].presence || @machine_reserve_fund.machine.machine_type_id
      @machines = machines_for(@selected_machine_type_id)
      render action: :edit, status: :unprocessable_content
    end
  end

  def destroy
    @machine_reserve_fund.destroy
    redirect_to @return_to, status: :see_other
  end

  def machines
    @machines = machines_for(params[:machine_type_id])
    respond_to { |format| format.turbo_stream }
  end

  private

  def set_machine_reserve_fund
    @machine_reserve_fund = MachineReserveFund.for_organization(current_organization).find(params.expect(:id))
  end

  def set_machine_types
    @machine_types = MachineType.usual
  end

  def machines_for(machine_type_id)
    return Machine.none if machine_type_id.blank?

    Machine.for_organization(current_organization).of_company.usual.where(machine_type_id: machine_type_id)
  end

  def machine_reserve_fund_params
    params.expect(machine_reserve_fund: [:machine_id, :started_on, :years, :total_amount, :remaining_amount])
  end
end
