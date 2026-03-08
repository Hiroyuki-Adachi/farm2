require "test_helper"

class Sorimachi::TotalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "農業簿記簡易集計(表示)" do
    get sorimachi_totals_path, params: {total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id}
    assert_response :success
    assert_select "th", text: "コード"
    assert_select "th", text: "名称"
  end
end
