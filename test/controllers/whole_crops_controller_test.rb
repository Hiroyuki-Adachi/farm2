require 'test_helper'

class WholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "WCS一覧" do
    work_whole_crop = work_whole_crops(:whole_crop1)
    system = systems(:s2015)

    assert_no_difference('WorkWholeCrop.count') do
      get whole_crops_path
    end
    assert_response :success

    work_whole_crop.reload
    assert_equal work_whole_crop.unit_price, system.roll_price
  end

  test "WCS一覧(管理者以外)" do
    login_as(users(:user_checker))
    get whole_crops_path
    assert_response :error
  end
end
