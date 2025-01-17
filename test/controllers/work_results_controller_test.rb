require 'test_helper'

class WorkResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別日当一覧" do
    get work_results_path
    assert_response :success

    get work_results_path, params: {fixed_at: "2015-02-28"}
    assert_response :success
  end
end
