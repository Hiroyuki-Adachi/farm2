class ZenginPaymentsController < ApplicationController
  include PermitManager

  before_action :set_fixed_at
  before_action :set_fix
  before_action :set_batch

  def show; end

  def create
    ZenginPaymentBatch.rebuild_for_fix!(
      organization: current_organization,
      term: current_term,
      fixed_at: @fixed_at,
      created_by: current_user.worker_id
    )

    redirect_to fix_zengin_payment_path(@fix), notice: "全銀データを作成しました。"
  end

  private

  def set_fixed_at
    @fixed_at = Date.strptime(params[:fix_fixed_at], '%Y-%m-%d')
  end

  def set_fix
    @fix = Fix.find([current_organization.id, current_term, @fixed_at])
  end

  def set_batch
    @batch = ZenginPaymentBatch
      .for_organization(current_organization)
      .includes(zengin_payments: [{worker: :home}, :zengin_payment_details])
      .find_by(term: current_term, fixed_at: @fixed_at)
  end
end
