require "test_helper"

class Statistics::WorkersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "作業者別作業一覧" do
    get statistics_workers_path
    assert_response :success
  end
end
