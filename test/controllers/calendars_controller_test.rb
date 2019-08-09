require 'test_helper'

class CalendarsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "カレンダー" do
    get :index
    assert_response :success
  end

  test "カレンダー(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
