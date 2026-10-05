class MachineReserveFundCostsController < ApplicationController
  include PermitManager

  before_action :set_work_types
  before_action :set_detail, except: :index

  def index
    @details = MachineReserveFundDetail.for_organization(current_organization).where(term: current_term)
      .joins(machine_reserve_fund: { machine: :machine_type })
      .includes(:machine_reserve_fund_costs, machine_reserve_fund: { machine: :machine_type })
      .order("machine_types.display_order", "machines.display_order", "machines.id")
    @costs = @details.to_h do |detail|
      [detail.id, detail.machine_reserve_fund_costs.index_by(&:work_type_id)]
    end
    @totals = @work_types.to_h do |work_type|
      [work_type.id, @costs.values.sum { |costs| costs[work_type.id]&.cost || 0 }]
    end
  end

  def edit
    @costs = @detail.prepare_costs
  end

  def update
    if @detail.update_costs(params.expect(costs: @work_types.map { |type| type.id.to_s }))
      redirect_to machine_reserve_fund_costs_path, notice: "基盤強化準備金原価を登録しました。"
    else
      @costs = @detail.prepare_costs
      render :edit, status: :unprocessable_content
    end
  end

  def reallocate
    if @detail.reallocate_costs(current_system)
      redirect_to edit_machine_reserve_fund_cost_path(@detail), notice: "基盤強化準備金原価を再按分しました。", status: :see_other
    else
      @costs = @detail.prepare_costs
      render :edit, status: :unprocessable_content
    end
  end

  private

  def set_work_types
    @work_types = WorkType.land.by_term(current_term).to_a
  end

  def set_detail
    @detail = MachineReserveFundDetail.for_organization(current_organization).where(term: current_term)
      .find(params.expect(:id))
  end
end
