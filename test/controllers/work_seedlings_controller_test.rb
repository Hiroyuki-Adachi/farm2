require 'test_helper'

class WorkSeedlingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "育苗集計(会計)" do
    get work_seedlings_path
    assert_response :success
  end
end
