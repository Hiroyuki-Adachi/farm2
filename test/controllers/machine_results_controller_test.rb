require 'test_helper'

class MachineResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "機械結果一覧" do
    get machine_results_path
    assert_response :success

    get machine_results_path, params: {fixed_at: "2015-02-28"}
    assert_response :success
  end
end
