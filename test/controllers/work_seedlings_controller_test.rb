require 'test_helper'

class WorkSeedlingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "育苗集計(会計)" do
    get :index
    assert_response :success
  end
end
