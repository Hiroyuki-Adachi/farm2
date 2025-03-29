require 'test_helper'

class TotalCostsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "原価一覧" do
    get total_costs_path
    assert_response :success
  end

  test "原価一覧(管理者以外)" do
    login_as(users(:user_checker))
    get total_costs_path
    assert_response :error
  end

  test "原価計算" do
    assert_enqueued_with(job: TotalCostsMakeJob) do
      post total_costs_path, params: { fixed_on: "2015-12-31" }
    end
    assert_redirected_to total_costs_path
  end
end
