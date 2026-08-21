require "test_helper"

class FuelCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "燃料原価一覧に他組織の機械を表示しない" do
    machines(:machine_other_org).update!(diesel_flag: true)

    get fuel_costs_path

    assert_response :success
    assert_not_includes response.body, homes(:home_other_org).name
  end

  test "自組織の機械稼働実績の燃料使用量を更新する" do
    machine_result = machine_results(:machine_results0)

    post fuel_costs_path, params: {
      light_oil_price: systems(:s2015).light_oil_price,
      machine_results: {
        machine_result.id => { fuel_usage: "12.3", old_usage: machine_result.fuel_usage.to_s }
      }
    }

    assert_redirected_to fuel_costs_path
    assert_equal 12.3, machine_result.reload.fuel_usage
  end

  test "他組織の機械稼働実績を更新しない" do
    machine_result = machine_results(:machine_result_other_org)
    original_fuel_usage = machine_result.fuel_usage

    post fuel_costs_path, params: {
      light_oil_price: systems(:s2015).light_oil_price,
      machine_results: {
        machine_result.id => { fuel_usage: "12.3", old_usage: original_fuel_usage.to_s }
      }
    }

    assert_response :not_found
    assert_equal original_fuel_usage, machine_result.reload.fuel_usage
  end
end
