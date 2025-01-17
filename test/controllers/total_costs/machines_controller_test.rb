require "test_helper"

class TotalCosts::MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "機械稼働一覧" do
    get total_costs_machines_path
    assert_response :success
  end

  test "機械稼働一覧(管理者以外)" do
    login_as(users(:user_checker))
    get total_costs_machines_path
    assert_response :error
  end
end
