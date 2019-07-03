require 'test_helper'

class CalendarWorkKindsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "カレンダー制御" do
    get :index
    assert_response :success
  end

  test "カレンダー制御(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
