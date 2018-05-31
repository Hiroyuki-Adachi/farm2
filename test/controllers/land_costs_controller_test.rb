require 'test_helper'

class LandCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @cost1 = land_costs(:cost1)
    @land_costs = {
      0 => {
        work_type_id: work_types(:work_types1).id, cost: 10_000, id:  @cost1.id,
        land_id: @cost1.land_id, term: @cost1.term
      },
      1 => {
        work_type_id: work_types(:work_types2).id, cost: 5000,
        land_id: lands(:lands2).id, term: @cost1.term
      }}
  end

  test "土地原価(表示)" do
    get :index
    assert_response :success
  end

  test "土地原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "土地原価新規作成(実行)" do
    assert_difference('LandCost.count') do
      post :create, land_costs: @land_costs
    end
    assert_redirected_to land_costs_path

    @cost1 = LandCost.find(@cost1.id)
    assert_equal @cost1.work_type_id, work_types(:work_types1).id
    assert_equal @cost1.cost, 10_000
  end
end
