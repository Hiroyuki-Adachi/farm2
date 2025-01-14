require 'test_helper'

class Plans::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_manager)
    login_as(@user)
    @mode = Plans::LandsController::TERM_MODES[:next]
    travel_to(Date.new(2015, 1, 1))
  end

  teardown do
    travel_back
  end

  test "作付計画(表示)" do
    get new_plans_land_path(mode: @mode)
    assert_response :success
  end

  test "作付計画(モード不正)" do
    get new_plans_land_path(mode: 999)
    assert_response :error
  end

  test "作付計画(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1)) do
      get new_plans_land_path(mode: @mode)
      assert_response :error
    end
  end

  test "作付計画(表示)(管理者以外)" do
    login_as(users(:user_checker))
    get new_plans_land_path(mode: @mode)
    assert_response :error
  end

  test "作付計画(登録)" do
    land = lands(:lands2)
    work_type = work_types(:work_types2)
    PlanLand.delete_all
    assert_difference('PlanLand.count') do
      post plans_lands_path(mode: @mode), params: {land: {land.id => work_type.id}}
    end
    assert_redirected_to new_plans_land_path(mode: @mode)

    term = @user.organization.get_term(Time.zone.today.next_year)

    created_plan_land = PlanLand.find_by(term: term, land_id: land.id, user_id: @user.id)
    assert_not_nil created_plan_land
    assert_equal work_type.id, created_plan_land.work_type_id
  end

  test "作付計画(初期化)" do
    delete plans_land_path(mode: @mode, id: 0)
    assert_redirected_to new_plans_land_path(mode: @mode)
  end
end
