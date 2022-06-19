require "test_helper"

class TotalCosts::MachinesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "機械稼働一覧" do
    get :index
    assert_response :success
  end

  test "機械稼働一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
