require "test_helper"

class Sorimachi::TotalsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "農業簿記簡易集計(表示)" do
    get sorimachi_totals_path
    assert_response :success
  end
end
