class ZenginPaymentsController < ApplicationController
  include PermitManager

  before_action :set_fixed_at
  before_action :set_fix
  before_action :set_batch

  def show; end


  def land_fee_template
    csv = ZenginPaymentBatch.land_fee_template_csv(current_organization)
    send_data csv.encode(Encoding::Windows_31J),
              filename: "zengin_land_fee_template_#{@fixed_at.strftime('%Y%m%d')}.csv",
              type: "text/csv; charset=Shift_JIS"
  end

  def land_fee_import
    unless @batch
      redirect_to fix_zengin_payment_path(@fix), alert: "先に全銀データを作成してください。"
      return
    end

    unless params[:land_fee_file]
      redirect_to fix_zengin_payment_path(@fix), alert: "CSVファイルを選択してください。"
      return
    end

    result = @batch.import_land_fee_csv!(params[:land_fee_file])
    duplicate_message = result[:duplicate_finance_orders].present? ? " 重複会計ID: #{result[:duplicate_finance_orders].join(', ')} は合算しました。" : ""
    redirect_to fix_zengin_payment_path(@fix), notice: "CSVを取り込みました。農地管理料 #{result[:imported_counts]['農地管理料']}件、小作地管理料 #{result[:imported_counts]['小作地管理料']}件。#{duplicate_message}"
  rescue CSV::MalformedCSVError, ActiveRecord::RecordInvalid => e
    redirect_to fix_zengin_payment_path(@fix), alert: "CSVを取り込めませんでした。#{e.message}"
  end

  def seedling_fee_import
    unless @batch
      redirect_to fix_zengin_payment_path(@fix), alert: "先に全銀データを作成してください。"
      return
    end

    result = @batch.import_seedling_fee!(term: current_term, seedling_price: current_system.seedling_price)
    redirect_to fix_zengin_payment_path(@fix), notice: "育苗費を取り込みました。#{result[:count]}件、#{helpers.number_with_delimiter(result[:amount])}円。"
  end

  def drying_adjustment_fee_import
    unless @batch
      redirect_to fix_zengin_payment_path(@fix), alert: "先に全銀データを作成してください。"
      return
    end

    result = @batch.import_drying_adjustment_fee!(term: current_term, system: current_system)
    redirect_to fix_zengin_payment_path(@fix), notice: "乾燥調整費を取り込みました。#{result[:count]}件、#{helpers.number_with_delimiter(result[:amount])}円。"
  end

  def export
    unless @batch
      redirect_to fix_zengin_payment_path(@fix), alert: "先に全銀データを作成してください。"
      return
    end

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
