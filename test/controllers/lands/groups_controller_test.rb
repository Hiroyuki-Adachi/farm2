require 'test_helper'

class Lands::GroupsControllerTest <  ActionController::TestCase
  setup do
    setup_ip
  end

  test "土地グループ(一覧)" do
    get :index
    assert_response :success
  end
end
