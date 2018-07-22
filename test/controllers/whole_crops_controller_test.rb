require 'test_helper'

class WholeCropsControllerTest <  ActionController::TestCase
  setup do
    setup_ip
  end

  test "WCS一覧" do
    get :index
    assert_response :success
  end

  test "WCS一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
