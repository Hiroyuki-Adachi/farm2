require "test_helper"

class Statistics::WorkDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別作業一覧" do
    get statistics_work_days_path
    assert_response :success
  end
end
