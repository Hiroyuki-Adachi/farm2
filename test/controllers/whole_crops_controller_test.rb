require 'test_helper'

class WholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "WCS一覧" do
    get whole_crops_path
    assert_response :success
  end

  test "WCS一覧(管理者以外)" do
    login_as(users(:user_checker))
    get whole_crops_path
    assert_response :error
  end

  test "WCS登録" do
    work_whole_crop = work_whole_crops(:whole_crop1)
    @new_whole_cop = {
      id: work_whole_crop.id,
      article_name: "TEST",
      unit_price: 20,
      tax_rate: 8
    }

    assert_no_difference('WorkWholeCrop.count') do
      post whole_crops_path, params: {whole_crop: [@new_whole_cop]}
    end
    assert_redirected_to whole_crops_path

    work_whole_crop.reload
    assert_equal @new_whole_cop[:article_name], work_whole_crop.article_name
    assert_equal @new_whole_cop[:unit_price], work_whole_crop.unit_price
    assert_equal @new_whole_cop[:tax_rate], work_whole_crop.tax_rate
  end
end
