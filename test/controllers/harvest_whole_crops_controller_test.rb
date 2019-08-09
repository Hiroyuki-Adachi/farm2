require 'test_helper'

class HarvestWholeCropsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "収穫一覧(WCS)" do
    get :index
    assert_response :success
  end

  test "収穫一覧(WCS)(検証者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end
end
