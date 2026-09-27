class MachineReserveFundDetailsController < ApplicationController
  include PermitManager

  before_action :set_fund, only: [:new, :create]

  def index
    @funds = MachineReserveFund.for_organization(current_organization)
      .includes(:machine_reserve_fund_details, machine: :machine_type).usual
      .select do |fund|
        fund.current_remaining_amount.positive? || fund.machine_reserve_fund_details.any? do |detail|
          detail.term == current_term
        end
      end
  end

  def new
    @detail = @fund.build_detail(current_system)
  end

  def create
    @detail = @fund.machine_reserve_fund_details.build(
      params.expect(machine_reserve_fund_detail: [:amount]).merge(organization: current_organization,
                                                                  term: current_term)
    )
    if @detail.register(current_system)
      redirect_to machine_reserve_fund_details_path, notice: "基盤強化準備金明細を登録しました。"
    else
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    detail = MachineReserveFundDetail.for_organization(current_organization)
      .where(term: current_term).find(params.expect(:id))
    detail.destroy_with_balance!
    redirect_to machine_reserve_fund_details_path, notice: "基盤強化準備金明細を削除しました。", status: :see_other
  end

  private

  def set_fund
    @fund = MachineReserveFund.for_organization(current_organization).find(params.expect(:machine_reserve_fund_id))
  end
end
