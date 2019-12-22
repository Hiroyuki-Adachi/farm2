require 'test_helper'

class OwnedRicesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "保有米一覧" do
    get :index
    assert_response :success
  end

  test "保有米一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "保有米変更(表示)" do
    get :edit, params: {id: 1}
    assert_response :success
  end

  test "保有米変更(実行)" do
    assert_no_difference('OwnedRice.count') do
      patch :update, params: {
        id: 1,
        owned_rices: {owned_rice_prices(:owned_rice_price1).id => {
          home_id: 1, owned_rice_price_id: owned_rice_prices(:owned_rice_price1), id: owned_rices(:owned_rice1),
          owned_count: 20
        }}
      }
    end
    assert_redirected_to owned_rices_path
  end

  test "保有米作成(実行)" do
    assert_difference('OwnedRice.count') do
      patch :update, params: {
        id: 2,
        owned_rices: {owned_rice_prices(:owned_rice_price1).id => {
          home_id: 2, owned_rice_price_id: owned_rice_prices(:owned_rice_price1),
          owned_count: 5
        }}
      }
    end
    assert_redirected_to owned_rices_path
  end
end
