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

    assert_no_difference -> { ZenginPaymentBatch.count } do
      post fix_zengin_payment_path(@fix)
    end
    assert_redirected_to fix_zengin_payment_path(@fix)
  end

  test "農地管理料CSVひな形ダウンロード" do
    get land_fee_template_fix_zengin_payment_path(@fix)

    assert_response :success
    assert_includes response.body.encode("UTF-8", "Windows-31J"), "会計ID,世帯名,農地管理料,小作地管理料,備考"
  end

  test "農地管理料CSV取込" do
    post fix_zengin_payment_path(@fix)
    batch = ZenginPaymentBatch.find_by(organization: @fix.organization, term: @fix.term, fixed_at: @fix.fixed_at)
    home = Home.for_organization(@fix.organization).kept.where(member_flag: true).detect(&:holder)
    home.update!(finance_order: 999)

    file = Tempfile.new(["land_fee", ".csv"])
    file.write("会計ID,世帯名,農地管理料,小作地管理料,備考\n")
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
    assert_equal 1500, payment.zengin_payment_details.where(source_kind: :imported, payment_type: :land_management_fee).sum(:amount).to_i
    assert_equal(-200, payment.zengin_payment_details.where(source_kind: :imported, payment_type: :tenant_land_management_fee).sum(:amount).to_i)
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

  test "確定一覧に全銀データへの導線を表示" do
    get fixes_path

    assert_response :success
    assert_select "a[href=?]", fix_zengin_payment_path(@fix), text: "全銀データ"
  end
end
