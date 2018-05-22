require 'test_helper'

class LandCostsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "土地原価(表示)" do
    get :index
    assert_response :success
  end
end
