require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "統計情報一覧" do
    get :index
    assert_response :success
  end

  test "統計情報一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
