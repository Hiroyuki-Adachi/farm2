require 'test_helper'

class WorkVerificationsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "日報検証一覧" do
    get :index
    assert_response :success
  end

  test "日報検証一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end
end
