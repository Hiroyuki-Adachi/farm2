require 'test_helper'

class Plans::LandsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end

  test "作付計画(表示)" do
    get :new
    assert_response :success
  end
end
