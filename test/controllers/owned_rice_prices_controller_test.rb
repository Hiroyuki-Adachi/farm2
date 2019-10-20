require 'test_helper'

class OwnedRicePricesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "保有米単価マスタ一覧" do
    get :index
    assert_response :success
  end

  test "保有米単価マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "保有米単価マスタ新規作成(実行)" do
    assert_difference('OwnedRicePrice.count') do
      post :create, params: {owned_rice_price: {
        work_type_id: 2, display_order: 20, name: "きぬむすめ", short_name: "きぬ",
        owned_price: 6500, relative_price: 7500, term: 2015
      }}
    end

    assert_redirected_to owned_rice_prices_path
  end

  test "保有米単価マスタ変更(表示)" do
    get :edit, params: {id: 1}
    assert_response :success
  end

  test "保有米単価マスタ変更(実行)" do
    assert_no_difference('OwnedRicePrice.count') do
      patch :update, params: {
        id: owned_rice_prices(:owned_rice_price1),
        owned_rice_price: {
          work_type_id: 1, display_order: 10, name: "コシヒカリ２", short_name: "コシ２",
          owned_price: 7000, relative_price: 8000, term: 2015
        }
      }
    end
    assert_redirected_to owned_rice_prices_path
  end

  test "保有米単価マスタ削除" do
    assert_difference('OwnedRicePrice.count', -1) do
      delete :destroy, params: {id: owned_rice_prices(:owned_rice_price1)}
    end
    assert_redirected_to owned_rice_prices_path
  end
end
