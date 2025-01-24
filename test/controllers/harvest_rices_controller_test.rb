require 'test_helper'

class HarvestRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "収穫一覧(水稲)" do
    get harvest_rices_path
    assert_response :success
  end

  test "収穫一覧(水稲)(検証者以外)" do
    login_as(users(:user_checker))
    get harvest_rices_path
    assert_response :error
  end
end
