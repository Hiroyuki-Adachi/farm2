require 'test_helper'

class LandCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @cost1 = land_costs(:cost1)
    @land_costs1 = {
      0 => {
        work_type_id: work_types(:work_types1).id, id:  @cost1.id,
        land_id: @cost1.land_id, activated_on: @cost1.activated_on
      },
      1 => {
        work_type_id: work_types(:work_types2).id, 
        land_id: lands(:lands2).id, activated_on: @cost1.activated_on
      }}
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
    get :index
    assert_response :success
  end

  test "土地原価(表示)(日付不正)" do
    travel_to(Date.new(2016, 1, 1))
    get :index
    assert_response :error
  end

  test "土地原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "土地原価新規作成(実行)" do
    assert_difference('LandCost.count') do
      post :create, params: {land_costs: @land_costs1}
    end
    assert_redirected_to land_costs_path

    @cost1 = LandCost.find(@cost1.id)
    assert_equal @cost1.work_type_id, work_types(:work_types1).id

    # 金額も作業種別も変更がない場合は対称とならない
    @cost1.activated_on = Date.new(2014, 12, 1)
    @cost1.save
    assert_no_difference('LandCost.count') do
      post :create, params: {land_costs: @land_costs2}
    end

    # 期首日より前は追加となる。
    @cost1.work_type_id = work_types(:work_types2).id
    @cost1.save
    assert_difference('LandCost.count') do
      post :create, params: {land_costs: @land_costs2}
    end
  end

  test "土地原価履歴" do
    get :edit, params: {land_id: lands(:land_land_cost1)}
    assert_response :success
  end

  test "土地原価履歴(更新:追加)" do
    assert_difference('LandCost.count') do
      patch :update, params: {land_id: lands(:land_land_cost1), land: @land_update}
    end
    assert_redirected_to land_costs_path(format: :html)
  end

  test "土地原価履歴(更新:削除)" do
    assert_difference('LandCost.count', -1) do
      patch :update, params: {land_id: lands(:land_land_cost1), land: @land_delete}
    end
    assert_redirected_to land_costs_path(format: :html)
  end

  test "土地原価管理(地図)" do
    get :map
    assert_response :success
  end
end
