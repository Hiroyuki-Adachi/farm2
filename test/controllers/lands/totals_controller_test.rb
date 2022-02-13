require "test_helper"

class Lands::TotalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "土地統計一覧(初期表示)" do
    get :index
    assert_response :success
  end

  test "土地統計一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "土地統計一覧(実行)" do
    get :index, params: {work_kinds: [work_kinds(:work_kind_taue).id]}
    assert_response :success
  end
end
