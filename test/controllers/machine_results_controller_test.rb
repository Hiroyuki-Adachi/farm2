require 'test_helper'

class MachineResultsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "機械結果一覧" do
    get :index
    assert_response :success

    get :index, fixed_at: "2015-02-28"
    assert_response :success
  end
end
