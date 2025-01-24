require "test_helper"

class Statistics::WorkDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別作業日数一覧" do
    get statistics_path
    assert_response :success
  end
end
