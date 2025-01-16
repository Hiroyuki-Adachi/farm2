require "test_helper"

class Lands::TotalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "土地統計一覧(初期表示)" do
    get lands_totals_path
    assert_response :success
  end

  test "土地統計一覧(検証者以外)" do
    login_as(users(:user_user))
    get lands_totals_path
    assert_response :error
  end

  test "土地統計一覧(実行)" do
    get lands_totals_path, params: {work_kinds: [work_kinds(:work_kind_taue).id]}
    assert_response :success
  end
end
