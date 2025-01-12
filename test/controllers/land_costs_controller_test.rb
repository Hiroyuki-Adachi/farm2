require 'test_helper'

class LandCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @cost1 = land_costs(:cost1)
    @land_costs1 = {
      0 => {
        work_type_id: work_types(:work_types1).id, id: @cost1.id,
        land_id: @cost1.land_id, activated_on: @cost1.activated_on
      },
      1 => {
        work_type_id: work_types(:work_types2).id, 
        land_id: lands(:lands2).id, activated_on: @cost1.activated_on
      }
    }
    @land_costs2 = {
      0 => {
        work_type_id: work_types(:work_types1).id, id: @cost1.id,
        land_id: @cost1.land_id, activated_on: @cost1.activated_on
      }
    }
    @land_update = {land_costs_attributes: [{activated_on: Date.new(2015, 5, 5), work_type_id: work_types(:work_types1).id}]}
    @land_delete = {land_costs_attributes: [{id: @cost1.id, _destroy: 1}]}
    travel_to(Date.new(2015, 1, 1))
  end

  test "土地原価(表示)" do
    get land_costs_path
    assert_response :success
  end

  test "土地原価(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1))
    get land_costs_path
    assert_response :error
  end

  test "土地原価(管理者以外)" do
    login_as(users(:user_checker))
    get land_costs_path
    assert_response :error
  end

  test "土地原価新規作成(実行)" do
    assert_difference('LandCost.count') do
      post land_costs_path, params: {land_costs: @land_costs1}
    end
    assert_redirected_to land_costs_path

    land_cost = LandCost.last
    assert_equal @land_costs1[1][:work_type_id], land_cost.work_type_id
    assert_equal @land_costs1[1][:land_id], land_cost.land_id
    assert_equal @land_costs1[1][:activated_on], land_cost.activated_on

    # 金額も作業種別も変更がない場合は対称とならない
    @cost1.activated_on = Date.new(2014, 12, 1)
    @cost1.save
    assert_no_difference('LandCost.count') do
      post land_costs_path, params: {land_costs: @land_costs2}
    end

    # 期首日より前は追加となる。
    @cost1.work_type_id = work_types(:work_types2).id
    @cost1.save
    assert_difference('LandCost.count') do
      post land_costs_path, params: {land_costs: @land_costs2}
    end

    land_cost = LandCost.last
    assert_equal @land_costs2[0][:work_type_id], land_cost.work_type_id
    assert_equal @land_costs2[0][:land_id], land_cost.land_id
    assert_equal @land_costs2[0][:activated_on], land_cost.activated_on
  end

  test "土地原価履歴" do
    get edit_land_cost_path(land_id: lands(:land_land_cost1).id)
    assert_response :success
  end

  test "土地原価履歴(更新:追加)" do
    assert_difference('LandCost.count') do
      patch land_cost_path(land_id: lands(:land_land_cost1).id), params: {land: @land_update}
    end
    assert_redirected_to land_costs_path(format: :html)

    land_cost = LandCost.last
    assert_equal @land_update[:land_costs_attributes][0][:work_type_id], land_cost.work_type_id
    assert_equal lands(:land_land_cost1).id, land_cost.land_id
    assert_equal @land_update[:land_costs_attributes][0][:activated_on], land_cost.activated_on
  end

  test "土地原価履歴(更新:削除)" do
    assert_difference('LandCost.count', -1) do
      patch land_cost_path(land_id: lands(:land_land_cost1).id), params: {land: @land_delete}
    end
    assert_redirected_to land_costs_path(format: :html)

    assert_nil LandCost.find_by(id: @cost1.id)
  end

  test "土地原価管理(地図)" do
    get map_land_costs_path
    assert_response :success
  end

  teardown do
    travel_back
  end
end
