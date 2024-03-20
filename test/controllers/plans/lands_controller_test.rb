require 'test_helper'

class Plans::LandsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
    travel_to(Date.new(2015, 1, 1))
  end

  test "作付計画(表示)" do
    get :new
    assert_response :success
    travel_back
  end

  test "作付計画(表示)(日付不正)" do
    travel_to(Date.new(2014, 1, 1))
    get :new
    assert_response :error
  end

  test "作付計画(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end

  test "作付計画(登録)" do
    land = lands(:lands2)
    work_type = work_types(:work_types2)
    PlanLand.delete_all
    assert_difference('PlanLand.count') do
      post :create, params: {land: {land.id => work_type.id}}
    end
    assert_redirected_to new_plans_land_path
  end

  test "作付計画(初期化)" do
    post :destroy, params: {id: 0}
    assert_redirected_to new_plans_land_path
  end
end
