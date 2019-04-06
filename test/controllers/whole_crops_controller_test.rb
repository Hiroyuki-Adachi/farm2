require 'test_helper'

class WholeCropsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "WCS一覧" do
    get :index
    assert_response :success
  end

  test "WCS一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "WCS登録" do
    assert_no_difference('WorkWholeCrop.count') do
      post :create, params: {
        whole_crop: [{
          id: work_whole_crops(:whole_crop1).id,
          article_name: "TEST",
          unit_price: 20,
          tax_rate: 8
        }]
      }
    end
    assert_redirected_to whole_crops_path
  end
end
