require "test_helper"

class TotalCosts::WorkResultsControllerTest <  ActionController::TestCase
  setup do
    setup_ip
  end

  test "原価区分別原価一覧" do
    get :index
    assert_response :success
  end

  test "原価区分別原価一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
