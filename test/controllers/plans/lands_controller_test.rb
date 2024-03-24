require 'test_helper'

class Plans::LandsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
    @mode = Plans::LandsController::TERM_MODES[:next]
    travel_to(Date.new(2015, 1, 1))
  end

  test "作付計画(表示)" do
    get :new, params: {mode: @mode}
    assert_response :success
  end

  test "作付計画(モード不正)" do
    get :new, params: {mode: 2}
    assert_response :error
  end

  test "作付計画(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1))
    get :new, params: {mode: @mode}
    assert_response :error
  end

  test "作付計画(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new, params: {mode: @mode}
    assert_response :error
  end

  test "作付計画(登録)" do
    land = lands(:lands2)
    work_type = work_types(:work_types2)
    PlanLand.delete_all
    assert_difference('PlanLand.count') do
      post :create, params: {land: {land.id => work_type.id}, mode: @mode}
    end
    assert_redirected_to new_plans_land_path(mode: @mode)
  end

  test "作付計画(初期化)" do
    post :destroy, params: {id: 0, mode: @mode}
    assert_redirected_to new_plans_land_path(mode: @mode)
  end
end
