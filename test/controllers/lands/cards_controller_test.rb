require 'test_helper'

class Lands::CardsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "土地カルテ(一覧)" do
    get :index
    assert_response :success
  end
end
