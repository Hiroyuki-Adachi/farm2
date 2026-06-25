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
    assert_select "input[name*='manual_other_amount']"
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
  end
end
