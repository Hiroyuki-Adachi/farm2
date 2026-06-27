class ZenginPaymentsController < ApplicationController
  include PermitManager

  before_action :set_fixed_at
  before_action :set_fix
  before_action :set_batch
  before_action :require_batch,
                only: [:edit, :update, :detail, :amount_change, :update_amount, :restore_amount, :payee_change, :update_payee, :land_fee_import, :seedling_fee_import, :drying_adjustment_fee_import, :export]

  def show; end

  def edit; end

  def create
    ZenginPaymentBatch.rebuild_for_fix!(
      organization: current_organization,
      term: current_term,
      fixed_at: @fixed_at,
      created_by: current_user.worker_id
    )

    redirect_to fix_zengin_payment_path(@fix), notice: "全銀データを作成しました。"
  end

  def update
    @batch.update_manual_other_details!(zengin_payment_params)
    redirect_to fix_zengin_payment_path(@fix), notice: "全銀データ保守を更新しました。"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: "全銀データ保守を更新できませんでした。#{e.message}"
  end

  def detail
    prepare_detail!
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def amount_change
    prepare_detail!
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def update_amount
    prepare_detail!
    @batch.update_detail_amounts!(
      payment: @payment,
      details: @details,
      detail_attributes: amount_detail_params
    )
    redirect_to edit_fix_zengin_payment_path(@fix), notice: "金額を変更しました。"
  rescue ActiveRecord::RecordInvalid, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: "金額を変更できませんでした。#{e.message}"
  rescue ActiveRecord::RecordNotFound => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def restore_amount
    prepare_detail!
    @batch.restore_detail_amounts!(payment: @payment, details: @details)
    redirect_to edit_fix_zengin_payment_path(@fix), notice: "金額を元に戻しました。"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: "金額を元に戻せませんでした。#{e.message}"
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def payee_change
    prepare_payee_change!
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def update_payee
    prepare_payee_change!
    target_worker = @returning ? @standard_worker : find_payee_candidate!(params[:worker_id])
    @batch.move_details_to_worker!(@target_details, target_worker)
    redirect_to edit_fix_zengin_payment_path(@fix), notice: "支払先を変更しました。"
  rescue ActiveRecord::RecordInvalid => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: "支払先を変更できませんでした。#{e.message}"
  rescue ActiveRecord::RecordNotFound, ArgumentError => e
    redirect_to edit_fix_zengin_payment_path(@fix), alert: e.message
  end

  def land_fee_template
    csv = ZenginPaymentBatch.land_fee_template_csv(current_organization)
    send_data csv.encode(Encoding::Windows_31J),
              filename: "zengin_land_fee_template_#{@fixed_at.strftime('%Y%m%d')}.csv",
              type: "text/csv; charset=Shift_JIS"
  end

  def land_fee_import
    unless params[:land_fee_file]
      redirect_to fix_zengin_payment_path(@fix), alert: "CSVファイルを選択してください。"
      return
    end

    result = @batch.import_land_fee_csv!(params[:land_fee_file])
    count_message = result[:imported_counts].map { |label, count| "#{label} #{count}件" }.join("、")
    duplicate_message = result[:duplicate_finance_orders].present? ? " 重複会計ID: #{result[:duplicate_finance_orders].join(', ')} は合算しました。" : ""
    redirect_to fix_zengin_payment_path(@fix), notice: "CSVを取り込みました。#{count_message}。#{duplicate_message}"
  rescue CSV::MalformedCSVError, ActiveRecord::RecordInvalid => e
    redirect_to fix_zengin_payment_path(@fix), alert: "CSVを取り込めませんでした。#{e.message}"
  end

  def seedling_fee_import
    result = @batch.import_seedling_fee!(term: current_term, seedling_price: current_system.seedling_price)
    redirect_to fix_zengin_payment_path(@fix),
                notice: "育苗費を取り込みました。#{result[:count]}件、#{helpers.number_with_delimiter(result[:amount])}円。"
  end

  def drying_adjustment_fee_import
    result = @batch.import_drying_adjustment_fee!(term: current_term, system: current_system)
    redirect_to fix_zengin_payment_path(@fix),
                notice: "乾燥調整費を取り込みました。#{result[:count]}件、#{helpers.number_with_delimiter(result[:amount])}円。"
  end

  def export
    transfer_on = Date.parse(params[:transfer_on].to_s)
    content = @batch.export_file!(transfer_on: transfer_on)
    send_data content,
              filename: "zengin_#{@fixed_at.strftime('%Y%m%d')}_#{transfer_on.strftime('%Y%m%d')}.dat",
              type: "text/plain; charset=Shift_JIS"
  rescue Date::Error
    redirect_to fix_zengin_payment_path(@fix), alert: "振込指定日を入力してください。"
  rescue ZenginPaymentBatch::ExportError => e
    redirect_to fix_zengin_payment_path(@fix), alert: e.message
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
      .includes(zengin_payments: [{ worker: :home }, :zengin_payment_details])
      .find_by(term: current_term, fixed_at: @fixed_at)
  end

  def require_batch
    return if @batch

    redirect_to fix_zengin_payment_path(@fix), alert: "先に全銀データを作成してください。"
  end

  def prepare_detail!
    @payment = @batch.zengin_payments.find(params[:payment_id])
    detail_ids = Array(params[:detail_ids]).reject(&:blank?).map(&:to_i).uniq
    @details = @payment.zengin_payment_details.where(id: detail_ids).order(:id).to_a
    raise ActiveRecord::RecordNotFound, "表示する明細が見つかりません。" unless @details.size == detail_ids.size

    @manual_entry = ActiveModel::Type::Boolean.new.cast(params[:manual_entry])
    raise ArgumentError, "表示する明細を選択してください。" if @details.blank? && !@manual_entry

    work_result_ids = @details.filter_map do |detail|
      detail.source_id if detail.payment_type_daily_wage? && detail.source_type == "WorkResult"
    end
    @work_results = WorkResult.includes(:work, :worker).where(id: work_result_ids).index_by(&:id)
  end

  def amount_detail_params
    params.fetch(:details, ActionController::Parameters.new).permit!.to_h
  end

  def prepare_payee_change!
    detail_ids = Array(params[:detail_ids]).reject(&:blank?)
    raise ArgumentError, "支払先変更する明細を選択してください。" if detail_ids.blank?

    @target_details = @batch.zengin_payment_details
      .includes(zengin_payment: { worker: { home: :holder } })
      .where(id: detail_ids)
      .to_a
    raise ActiveRecord::RecordNotFound, "支払先変更する明細が見つかりません。" unless @target_details.size == detail_ids.size

    payment_ids = @target_details.map(&:zengin_payment_id).uniq
    raise ArgumentError, "複数の支払先にまたがる明細は一度に変更できません。" unless payment_ids.one?

    @source_payment = @target_details.first.zengin_payment
    @home = @source_payment.worker.home
    @standard_worker = @home.holder
    raise ArgumentError, "標準支払先が設定されていません。" unless @standard_worker

    @returning = @source_payment.worker_id != @standard_worker.id
    @candidate_workers = payee_candidate_workers(@home).reject { |worker| worker.id == @source_payment.worker_id }
  end

  def payee_candidate_workers(home)
    home.workers.kept.select { |worker| !worker.account_incomplete? }
  end

  def find_payee_candidate!(worker_id)
    worker = @candidate_workers.detect { |candidate| candidate.id == worker_id.to_i }
    raise ActiveRecord::RecordNotFound, "支払先候補が見つかりません。" unless worker

    worker
  end

  def zengin_payment_params
    params.fetch(:zengin_payments, ActionController::Parameters.new).permit!
  end

  def menu_name
    :fixes
  end
end
