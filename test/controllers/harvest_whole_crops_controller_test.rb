require 'test_helper'

class HarvestWholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "収穫一覧(WCS)" do
    get harvest_whole_crops_path
    assert_response :success
  end

  test "収穫一覧(WCS)(検証者以外)" do
    login_as(users(:user_checker))
    get harvest_whole_crops_path
    assert_response :error
  end
end
