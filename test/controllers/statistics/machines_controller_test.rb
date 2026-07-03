require "test_helper"

class Statistics::MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "年度別機械稼働時間一覧" do
    get statistics_machines_path
    assert_response :success
  end
end
