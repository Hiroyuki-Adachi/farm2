require 'test_helper'

class WorkSeedlingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "should get index" do
    get work_seedlings_index_url
    assert_response :success
  end
end
