require 'test_helper'

class FuelCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "燃料原価" do
    get :index
    assert_response :success
  end

  test "燃料原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
