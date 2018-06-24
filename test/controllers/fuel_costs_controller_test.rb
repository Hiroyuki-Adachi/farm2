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

  test "土地原価新規作成(実行)" do
    light_oil_price = 99
    fuel_usage = 25
    assert_no_difference('System.count') do
      assert_no_difference('MachineResult.count') do
        post :create, {
          light_oil_price: light_oil_price,
          machine_results: {machine_results(:machine_results0).id => {
            fuel_usage: fuel_usage, old_usage: 0
        }}}
      end
    end
    assert_redirected_to fuel_costs_path

    @system = System.find_by(term: 2015, organization_id: 1)
    assert_equal @system.light_oil_price, light_oil_price
    @machine_result = MachineResult.find(machine_results(:machine_results0).id)
    assert_equal @machine_result.fuel_usage, fuel_usage
  end
end
