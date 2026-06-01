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
      post plans_lands_path(mode: @mode), params: { land: { land.id => work_type.id } }
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

  test "作付計画の初期化で他組織の土地を登録しない" do
    other_land = lands(:land_other_org)
    other_land.update!(region: "((35.474177,133.047340), (35.472866,133.047340), (35.472648,133.049056))")
    LandCost.create!(land: other_land, work_type: work_types(:work_type_koshi), activated_on: Date.new(1900, 1, 1))

    delete plans_land_path(mode: @mode, id: 0)

    term = @user.organization.get_term(Time.zone.today.next_year)
    assert_nil PlanLand.find_by(term: term, land_id: other_land.id, user_id: @user.id)
  end
end
