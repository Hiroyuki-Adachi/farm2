require "test_helper"
require "tempfile"

class ZenginPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @fix = fixes(:fix1)
  end

  test "全銀データ画面表示" do
    get fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "h1", /全銀データ/
    assert_select "button", text: "全銀データ作成"
    assert_select "td", text: "上のボタンから全銀データを作成してください。"
  end

  test "全銀データ未作成では保守画面を表示しない" do
    get edit_fix_zengin_payment_path(@fix)

    assert_redirected_to fix_zengin_payment_path(@fix)
    assert_equal "先に全銀データを作成してください。", flash[:alert]
  end

  test "全銀データ作成" do
    assert_difference -> { ZenginPaymentBatch.count }, 1 do
      post fix_zengin_payment_path(@fix)
    end

    assert_redirected_to fix_zengin_payment_path(@fix)

    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    assert_not_nil batch
    assert_operator batch.zengin_payments.count, :>, 0
    assert batch.zengin_payments.all? { |payment| payment.worker.home.member_flag? }
    assert_operator batch.zengin_payment_details.where(payment_type: :daily_wage).count, :>, 0
    assert batch.zengin_payment_details.select(&:source_kind_generated?).all? { |detail| detail.original_amount.to_i == detail.amount.to_i }

    assert_no_difference -> { ZenginPaymentBatch.count } do
      post fix_zengin_payment_path(@fix)
    end
    assert_redirected_to fix_zengin_payment_path(@fix)
  end

  test "全銀データ保守画面表示" do
    post fix_zengin_payment_path(@fix)

    get edit_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "h1", /全銀データ保守/
    assert_select "h2", /.+ \/ .+/
    assert_select "th", text: "元金額"
    assert_select "th", text: "支払金額"
    assert_select "a", text: "支払先変更"
    assert_select "a", text: "詳細"
    assert_select "input[type=submit]", { value: "更新", count: 0 }
    assert_select "button", { text: "分割", count: 0 }

    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    daily_wage_detail = batch.zengin_payment_details.find_by!(payment_type: :daily_wage)
    daily_wage_worker = WorkResult.find(daily_wage_detail.source_id).worker
    assert_select "td", text: daily_wage_worker.name
    assert_select "td", text: "その他"

    assert_select "input[name*='manual_other_amount']", count: 0
  end

  test "全銀データ保守画面の育苗費項目は名前のみ表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by!(
      organization: @fix.organization,
      term: @fix.term,
      fixed_at: @fix.fixed_at
    )
    payment = standard_payment_with_details(batch)
    payment.zengin_payment_details.create!(
      payment_type: :seedling_fee,
      source_kind: :generated,
      amount: 1_000,
      original_amount: 1_000,
      source_label: "育苗費 コシヒカリ"
    )

    get edit_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "td", text: "コシヒカリ"
    assert_select "td", { text: "育苗費 コシヒカリ", count: 0 }
  end

  test "全銀データ保守画面は日当元データを一括取得" do
    post fix_zengin_payment_path(@fix)
    work_result_queries = []
    subscriber = ActiveSupport::Notifications.subscribe("sql.active_record") do |_name, _started, _finished, _unique_id, payload|
      sql = payload[:sql]
      work_result_queries << sql if sql.match?(/FROM "work_results"/) && payload[:name] != "SCHEMA"
    end

    get edit_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_equal 1, work_result_queries.size
  ensure
    ActiveSupport::Notifications.unsubscribe(subscriber) if subscriber
  end

  test "明細詳細モーダルを表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    details = payment.zengin_payment_details.where(payment_type: :daily_wage).to_a
    details = [payment.zengin_payment_details.first] if details.blank?
    get detail_fix_zengin_payment_path(@fix), params: { payment_id: payment.id, detail_ids: details.map(&:id) }

    assert_response :success
    assert_select "turbo-frame#zengin_payment_modal"
    assert_select "h5", text: "明細詳細"
    assert_select "dd", text: payment.worker.home.name
    assert_select "dd", text: payment.worker.name
    assert_select "tbody tr", count: details.size
    assert_select "#zengin-payment-detail-modal form", count: 0
  end

  test "未登録のその他も明細詳細モーダルを表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)

    get detail_fix_zengin_payment_path(@fix), params: { payment_id: payment.id, manual_entry: true }

    assert_response :success
    assert_select "h5", text: "明細詳細"
    assert_select ".alert", text: /その他の明細は登録されていません/
  end

  test "金額変更モーダルを表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first

    get amount_change_fix_zengin_payment_path(@fix), params: { payment_id: payment.id, detail_ids: [detail.id] }

    assert_response :success
    assert_select "h5", text: "金額変更"
    assert_select ".alert-danger", text: /変更理由・備考/
    assert_select "input[name=?]", "details[#{detail.id}][amount]"
    assert_select "input[name=?]", "details[#{detail.id}][remarks]"
  end

  test "明細の金額を変更して元金額を維持" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first
    original_amount = detail.original_amount.to_i
    payment_amount = payment.amount.to_i
    changed_amount = detail.amount.to_i + 321

    patch amount_change_fix_zengin_payment_path(@fix), params: {
      payment_id: payment.id,
      detail_ids: [detail.id],
      details: { detail.id => { amount: changed_amount, remarks: "緊急調整" } }
    }

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    assert_equal "金額を変更しました。", flash[:notice]
    assert_equal changed_amount, detail.reload.amount.to_i
    assert_equal original_amount, detail.original_amount.to_i
    assert_equal "緊急調整", detail.remarks
    assert detail.amount_modified?
    assert_equal payment_amount + 321, payment.reload.amount.to_i
  end

  test "変更理由なしでは明細の金額を変更しない" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first
    amount = detail.amount.to_i

    patch amount_change_fix_zengin_payment_path(@fix), params: {
      payment_id: payment.id,
      detail_ids: [detail.id],
      details: { detail.id => { amount: amount + 1, remarks: "" } }
    }

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    assert_match(/変更理由・備考を入力してください/, flash[:alert])
    assert_equal amount, detail.reload.amount.to_i
  end

  test "未登録のその他を金額変更モーダルから追加" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    payment_amount = payment.amount.to_i

    get amount_change_fix_zengin_payment_path(@fix), params: { payment_id: payment.id, manual_entry: true }

    assert_response :success
    assert_select "input[name=?]", "details[new][amount]"
    assert_select "input[name=?]", "details[new][remarks]"

    assert_difference -> { payment.zengin_payment_details.count }, 1 do
      patch amount_change_fix_zengin_payment_path(@fix), params: {
        payment_id: payment.id,
        manual_entry: true,
        details: { new: { amount: -500, remarks: "臨時調整" } }
      }
    end

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    detail = payment.zengin_payment_details.find_by!(payment_type: :other, source_kind: :manual, source_label: "その他")
    assert_equal(-500, detail.amount.to_i)
    assert_equal 0, detail.original_amount.to_i
    assert_equal "臨時調整", detail.remarks
    assert_equal payment_amount - 500, payment.reload.amount.to_i
  end

  test "変更済み行だけに金額を元に戻すボタンを表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first
    detail.update!(amount: detail.amount.to_i + 100, remarks: "残す備考")
    payment.recalculate_amount!

    get edit_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "a", { text: "金額を元に戻す", count: 1 } do |links|
      assert_equal "patch", links.first["data-turbo-method"]
      assert_match(/備考は変更しません/, links.first["data-turbo-confirm"])
    end
  end

  test "変更済み明細の金額だけを元に戻す" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first
    original_payment_amount = payment.amount.to_i
    detail.update!(amount: detail.amount.to_i + 100, remarks: "残す備考")
    payment.recalculate_amount!

    patch restore_amount_fix_zengin_payment_path(@fix), params: {
      payment_id: payment.id,
      detail_ids: [detail.id]
    }

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    assert_equal "金額を元に戻しました。", flash[:notice]
    assert_equal detail.original_amount.to_i, detail.reload.amount.to_i
    assert_equal "残す備考", detail.remarks
    assert_equal original_payment_amount, payment.reload.amount.to_i
  end

  test "支払先変更モーダルを表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    detail = payment.zengin_payment_details.first
    target_worker = payee_candidate_for(payment)

    get payee_change_fix_zengin_payment_path(@fix), params: { detail_ids: [detail.id] }

    assert_response :success
    assert_select "turbo-frame#zengin_payment_modal"
    assert_select "h5", text: "支払先変更"
    assert_select "select[name=?]", "worker_id"
    assert_select "option[value=?]", target_worker.id.to_s
  end

  test "支払先変更は明細を移動して空になった支払先を削除" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    target_worker = payee_candidate_for(payment)
    detail_ids = payment.zengin_payment_details.ids
    source_payment_id = payment.id
    original_amount = payment.amount.to_i

    patch payee_change_fix_zengin_payment_path(@fix), params: { detail_ids: detail_ids, worker_id: target_worker.id }

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    assert_equal "支払先を変更しました。", flash[:notice]
    assert_not ZenginPayment.exists?(source_payment_id)
    target_payment = batch.reload.zengin_payments.find_by!(worker: target_worker)
    assert_equal original_amount, target_payment.amount.to_i
    assert_equal detail_ids.sort, target_payment.zengin_payment_details.ids.sort
  end

  test "標準支払先以外の明細は標準支払先へ戻せる" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = standard_payment_with_details(batch)
    standard_worker = payment.worker
    target_worker = payee_candidate_for(payment)
    detail_ids = payment.zengin_payment_details.ids
    batch.move_details_to_worker!(payment.zengin_payment_details.to_a, target_worker)

    get payee_change_fix_zengin_payment_path(@fix), params: { detail_ids: detail_ids }

    assert_response :success
    assert_select "h5", text: "支払先を戻す"
    assert_select "select[name=?]", "worker_id", count: 0

    patch payee_change_fix_zengin_payment_path(@fix), params: { detail_ids: detail_ids }

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    returned_payment = batch.reload.zengin_payments.find_by!(worker: standard_worker)
    assert_equal detail_ids.sort, returned_payment.zengin_payment_details.ids.sort
  end

  test "全銀データ保守でその他手入力を更新" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = batch.zengin_payments.includes(:zengin_payment_details).first
    original_amount = payment.amount.to_i

    assert_difference -> { ZenginPaymentDetail.where(source_kind: :manual, payment_type: :other).count }, 1 do
      patch fix_zengin_payment_path(@fix), params: {
        zengin_payments: {
          payment.id => {
            manual_other_amount: "1,234",
            manual_other_remarks: "端数調整"
          }
        }
      }
    end

    assert_redirected_to fix_zengin_payment_path(@fix)
    payment.reload
    detail = payment.zengin_payment_details.find_by(source_kind: :manual, payment_type: :other, source_label: "その他")
    assert_not_nil detail
    assert_equal 1234, detail.amount.to_i
    assert_equal 0, detail.original_amount.to_i
    assert detail.amount_modified?
    assert_equal "端数調整", detail.remarks
    assert_equal original_amount + 1234, payment.amount.to_i

    assert_difference -> { ZenginPaymentDetail.where(source_kind: :manual, payment_type: :other).count }, -1 do
      patch fix_zengin_payment_path(@fix), params: {
        zengin_payments: {
          payment.id => {
            manual_other_amount: "0",
            manual_other_remarks: ""
          }
        }
      }
    end

    assert_nil payment.reload.zengin_payment_details.find_by(source_kind: :manual, payment_type: :other, source_label: "その他")
    assert_equal original_amount, payment.amount.to_i
  end

  test "その他の不正な手入力金額で既存明細を削除しない" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = batch.zengin_payments.includes(:zengin_payment_details).first
    detail = payment.zengin_payment_details.create!(
      payment_type: :other,
      source_kind: :manual,
      source_label: "その他",
      amount: 123,
      original_amount: 0,
      remarks: "既存"
    )
    payment.recalculate_amount!
    payment_amount = payment.amount.to_i

    assert_no_difference -> { ZenginPaymentDetail.count } do
      patch fix_zengin_payment_path(@fix), params: {
        zengin_payments: {
          payment.id => {
            manual_other_amount: "abc",
            manual_other_remarks: ""
          }
        }
      }
    end

    assert_redirected_to edit_fix_zengin_payment_path(@fix)
    assert_match(/金額は整数で入力してください/, flash[:alert])
    assert_equal 123, detail.reload.amount.to_i
    assert_equal payment_amount, payment.reload.amount.to_i
  end

  test "全銀データ保守は未変更行を更新しない" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    changed, unchanged = batch.zengin_payments.order(:id).limit(2).to_a
    unchanged.update_column(:updated_at, 1.day.ago)
    unchanged_updated_at = unchanged.reload.updated_at

    patch fix_zengin_payment_path(@fix), params: {
      zengin_payments: {
        changed.id => {
          manual_other_amount: "100",
          manual_other_remarks: "調整"
        },
        unchanged.id => {
          manual_other_amount: "",
          manual_other_remarks: ""
        }
      }
    }

    assert_redirected_to fix_zengin_payment_path(@fix)
    assert_not_nil changed.reload.zengin_payment_details.find_by(source_kind: :manual, payment_type: :other, source_label: "その他")
    assert_nil unchanged.reload.zengin_payment_details.find_by(source_kind: :manual, payment_type: :other, source_label: "その他")
    assert_equal unchanged_updated_at.to_i, unchanged.updated_at.to_i
  end

  test "全銀データ再作成直後は農地管理料と小作地管理料を固定列に表示しない" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = batch.zengin_payments.first
    payment.zengin_payment_details.create!(
      payment_type: :other,
      source_kind: :imported,
      amount: 100,
      original_amount: 100,
      source_label: "農地管理料"
    )
    payment.recalculate_amount!

    post fix_zengin_payment_path(@fix)
    get fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "th", { text: "農地管理料", count: 0 }
    assert_select "th", { text: "小作地管理料", count: 0 }
  end

  test "全銀データ画面は固定列、取込列、その他の順に表示" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    payment = batch.zengin_payments.first
    payment.zengin_payment_details.create!(
      payment_type: :other,
      source_kind: :imported,
      amount: 100,
      original_amount: 100,
      source_label: "農地管理料"
    )
    payment.recalculate_amount!

    get fix_zengin_payment_path(@fix)

    assert_response :success
    labels = css_select("table thead th").map { |node| node.text.strip }
    assert_operator labels.index("乾燥調整費"), :<, labels.index("農地管理料")
    assert_operator labels.index("農地管理料"), :<, labels.index("その他")
    assert_operator labels.index("その他"), :<, labels.index("合計")
  end

  test "農地管理料CSVひな形ダウンロード" do
    get land_fee_template_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_includes response.body.encode("UTF-8", "Windows-31J"), "会計ID,世帯名,農地管理料,小作地管理料,備考"
  end

  test "CSV任意項目取込" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    home = Home.for_organization(@fix.organization).kept.where(member_flag: true).detect(&:holder)
    home.update!(finance_order: 999)

    file = Tempfile.new(["land_fee", ".csv"])
    file.write("会計ID,世帯名,農地管理料,調整金,備考\n")
    file.write("#{home.finance_order},#{home.name},1000,-200,\n")
    file.write("#{home.finance_order},#{home.name},500,,重複\n")
    file.close

    assert_difference -> { ZenginPaymentDetail.where(source_kind: :imported).count }, 2 do
      post land_fee_import_fix_zengin_payment_path(@fix), params: { land_fee_file: Rack::Test::UploadedFile.new(file.path, "text/csv") }
    end

    assert_redirected_to fix_zengin_payment_path(@fix)
    batch.reload
    payment = batch.zengin_payments.find_by(worker: home.holder)
    assert_not_nil payment
    land_fee_detail = payment.zengin_payment_details.find_by!(source_kind: :imported, payment_type: :other, source_label: "農地管理料")
    adjustment_detail = payment.zengin_payment_details.find_by!(source_kind: :imported, payment_type: :other, source_label: "調整金")
    assert_equal 1500, land_fee_detail.amount.to_i
    assert_equal 1500, land_fee_detail.original_amount.to_i
    assert_not land_fee_detail.amount_modified?
    assert_equal(-200, adjustment_detail.amount.to_i)
    assert_equal(-200, adjustment_detail.original_amount.to_i)
  ensure
    file&.unlink
  end

  test "CSV取込は重複ヘッダーを許可しない" do
    post fix_zengin_payment_path(@fix)
    home = Home.for_organization(@fix.organization).kept.where(member_flag: true).detect(&:holder)
    home.update!(finance_order: 999)

    file = Tempfile.new(["land_fee", ".csv"])
    file.write("会計ID,世帯名,調整金,調整金,備考\n")
    file.write("#{home.finance_order},#{home.name},1000,200,\n")
    file.close

    assert_no_difference -> { ZenginPaymentDetail.where(source_kind: :imported).count } do
      post land_fee_import_fix_zengin_payment_path(@fix), params: { land_fee_file: Rack::Test::UploadedFile.new(file.path, "text/csv") }
    end

    assert_redirected_to fix_zengin_payment_path(@fix)
    assert_match(/列名が重複/, flash[:alert])
  ensure
    file&.unlink
  end

  test "育苗費取込" do
    systems(:s2015).update!(seedling_price: 400)
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)

    assert_difference -> { ZenginPaymentDetail.where(payment_type: :seedling_fee, source_kind: :generated).count }, 1 do
      post seedling_fee_import_fix_zengin_payment_path(@fix)
    end

    assert_redirected_to fix_zengin_payment_path(@fix)
    batch.reload
    home = seedling_homes(:seedling_home1).home
    payment = batch.zengin_payments.find_by(worker: home.holder)
    assert_not_nil payment
    assert_equal 80000, payment.zengin_payment_details.where(payment_type: :seedling_fee, source_kind: :generated).sum(:amount).to_i

    assert_no_difference -> { ZenginPaymentDetail.where(payment_type: :seedling_fee, source_kind: :generated).count } do
      post seedling_fee_import_fix_zengin_payment_path(@fix)
    end

    batch.reload
    payment = batch.zengin_payments.find_by(worker: home.holder)
    assert_equal 80000, payment.zengin_payment_details.where(payment_type: :seedling_fee, source_kind: :generated).sum(:amount).to_i
  end

  test "乾燥調整費取込" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    homes = [homes(:home30), homes(:home31)]
    expected_amounts = homes.to_h do |home|
      [home, Drying.by_home(@fix.term, home).sum { |drying| drying.total_amount(systems(:s2015), home.id).to_i }]
    end

    assert_difference -> { ZenginPaymentDetail.where(payment_type: :drying_adjustment_fee, source_kind: :generated).count }, 2 do
      post drying_adjustment_fee_import_fix_zengin_payment_path(@fix)
    end

    assert_redirected_to fix_zengin_payment_path(@fix)
    batch.reload
    homes.each do |home|
      payment = batch.zengin_payments.find_by(worker: home.holder)
      assert_not_nil payment
      assert_equal expected_amounts[home], payment.zengin_payment_details.where(payment_type: :drying_adjustment_fee, source_kind: :generated).sum(:amount).to_i
    end

    assert_no_difference -> { ZenginPaymentDetail.where(payment_type: :drying_adjustment_fee, source_kind: :generated).count } do
      post drying_adjustment_fee_import_fix_zengin_payment_path(@fix)
    end

    batch.reload
    homes.each do |home|
      payment = batch.zengin_payments.find_by(worker: home.holder)
      assert_equal expected_amounts[home], payment.zengin_payment_details.where(payment_type: :drying_adjustment_fee, source_kind: :generated).sum(:amount).to_i
    end
  end

  test "全銀ファイル出力" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    batch.zengin_payments.destroy_all
    batch.zengin_payments.create!(
      worker: workers(:worker1),
      bank_code: "0001",
      branch_code: "001",
      account_type_id: :regular,
      account_number: "2345678",
      account_holder_name: "ｺﾞﾄｳ ﾊﾙﾐ",
      amount: 12_345
    )

    post export_fix_zengin_payment_path(@fix), params: { transfer_on: Time.zone.today }

    assert_response :success
    batch.reload
    assert_not_nil batch.exported_at

    records = response.body.b.split("\r\n".b)
    assert_equal 4, records.size
    assert_equal ["1", "2", "8", "9"], records.map { |record| record.byteslice(0, 1) }
    assert records.all? { |record| record.bytesize == ZenginPaymentBatch::ZENGIN_RECORD_BYTES }
    assert_equal "000001", records[2].byteslice(1, 6)
    assert_equal "000000012345", records[2].byteslice(7, 12)
  end

  test "支払結果Excel出力" do
    post fix_zengin_payment_path(@fix)

    get results_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_equal Mime[:xlsx].to_s, response.media_type
    assert_match(/zengin_results_#{@fix.fixed_at.strftime('%Y%m%d')}\.xlsx/, response.headers["Content-Disposition"])
  end

  test "全銀ファイル出力は過去日を許可しない" do
    post fix_zengin_payment_path(@fix)

    post export_fix_zengin_payment_path(@fix), params: { transfer_on: Time.zone.yesterday }

    assert_redirected_to fix_zengin_payment_path(@fix)
    assert_equal "振込指定日は本日以降を指定してください。", flash[:alert]
  end

  test "全銀ファイル出力は口座不備がある場合に出力しない" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)

    post export_fix_zengin_payment_path(@fix), params: { transfer_on: Time.zone.today }

    assert_redirected_to fix_zengin_payment_path(@fix)
    assert_match(/口座情報が未設定/, flash[:alert])
    assert_nil batch.reload.exported_at
  end

  test "確定一覧に全銀データへの導線を表示" do
    get fixes_path

    assert_response :success
    assert_select "a[href=?]", fix_zengin_payment_path(@fix), text: "全銀データ"
  end

  test "全銀データ画面に保守への導線を表示" do
    post fix_zengin_payment_path(@fix)

    get fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select "a[href=?]", edit_fix_zengin_payment_path(@fix), text: "保守"
    assert_select "a[href=?]", results_fix_zengin_payment_path(@fix), text: "支払結果Excel出力"
  end

  private

  def standard_payment_with_details(batch)
    batch.zengin_payments
      .includes(:zengin_payment_details, worker: { home: :holder })
      .detect { |payment| payment.worker_id == payment.worker.home.worker_id && payment.zengin_payment_details.exists? }
  end

  def payee_candidate_for(payment)
    home = payment.worker.home
    worker = home.workers.where.not(id: payment.worker_id).first || home.workers.create!(
      organization: @fix.organization,
      family_name: "試験",
      first_name: "太郎",
      family_phonetic: "しけん",
      first_phonetic: "たろう",
      display_order: 999,
      work_flag: true
    )
    worker.update!(
      bank_code: "0001",
      branch_code: "001",
      account_type_id: :regular,
      account_number: "2345678",
      account_holder_name: "TEST TARO"
    )
    worker
  end

end
