require 'test_helper'

class LandCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @cost1 = land_costs(:cost1)
    @land_costs = {
      0 => {
        work_type_id: work_types(:work_types1).id, cost: 10_000, id:  @cost1.id,
        land_id: @cost1.land_id, activated_on: @cost1.activated_on
      },
      1 => {
        work_type_id: work_types(:work_types2).id, cost: 5000,
        land_id: lands(:lands2).id, activated_on: @cost1.activated_on
      }}
    @land_update = {land_costs_attributes: [{activated_on: Date.new(2015, 5, 5), work_type_id: work_types(:work_types1).id, cost: 123_000}]}
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

  test "土地原価履歴" do
    get :edit, land_id: lands(:lands0)
    assert_response :success
  end

  test "土地原価履歴(更新)" do
    assert_difference('LandCost.count') do
      get :update, {land_id: lands(:lands0), land: @land_update}
    end
    assert_redirected_to land_costs_path
  end
end
