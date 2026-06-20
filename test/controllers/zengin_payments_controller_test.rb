require "test_helper"

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

  test "確定一覧に全銀データへの導線を表示" do
    get fixes_path

    assert_response :success
    assert_select "a[href=?]", fix_zengin_payment_path(@fix), text: "全銀データ"
  end
end
