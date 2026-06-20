require 'test_helper'

class ZenginPaymentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @fix = fixes(:fix1)
  end

  test "全銀データ画面表示" do
    get fix_zengin_payment_path(@fix)

    assert_response :success
    assert_select 'h1', /全銀データ/
    assert_select 'td', text: '作成機能は未実装です。'
  end

  test "確定一覧に全銀データへの導線を表示" do
    get fixes_path

    assert_response :success
    assert_select 'a[href=?]', fix_zengin_payment_path(@fix), text: '全銀データ'
  end
end
