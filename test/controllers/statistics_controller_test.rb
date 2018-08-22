require 'test_helper'

class StatisticsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "統計情報一覧" do
    get :index
    assert_response :success
  end

  test "統計情報一覧(利用者)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end
end
