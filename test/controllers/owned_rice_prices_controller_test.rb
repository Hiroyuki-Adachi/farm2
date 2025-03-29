require 'test_helper'

class OwnedRicePricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @owned_rice_price = owned_rice_prices(:owned_rice_price1)
  end

  test "保有米単価マスタ一覧" do
    get owned_rice_prices_path
    assert_response :success
  end

  test "保有米単価マスタ一覧(管理者以外)" do
    login_as(users(:user_checker))
    get owned_rice_prices_path
    assert_response :error
  end

  test "保有米単価マスタ新規作成(実行)" do
    new_owned_rice_price = {
      work_type_id: 2, display_order: 20, name: "きぬむすめ", short_name: "きぬ",
      owned_price: 6500, term: 2015
    }
    assert_difference('OwnedRicePrice.count') do
      post owned_rice_prices_path, params: {owned_rice_price: new_owned_rice_price}
    end
    assert_redirected_to owned_rice_prices_path

    owned_rice_price = OwnedRicePrice.last
    assert_equal new_owned_rice_price[:work_type_id], owned_rice_price.work_type_id
    assert_equal new_owned_rice_price[:display_order], owned_rice_price.display_order
    assert_equal new_owned_rice_price[:name], owned_rice_price.name
    assert_equal new_owned_rice_price[:short_name], owned_rice_price.short_name
    assert_equal new_owned_rice_price[:owned_price], owned_rice_price.owned_price
    assert_equal new_owned_rice_price[:term], owned_rice_price.term
  end

  test "保有米単価マスタ変更(表示)" do
    get edit_owned_rice_price_path(work_types(:work_type_koshi).id)
    assert_response :success
  end

  test "保有米単価マスタ変更(実行)" do
    new_owned_rice_price = {
      work_type_id: 1, display_order: 10, name: "コシヒカリ２", short_name: "コシ２",
      owned_price: 7000, term: 2015
    }
    assert_no_difference('OwnedRicePrice.count') do
      patch owned_rice_price_path(@owned_rice_price.id), params: {owned_rice_price: new_owned_rice_price}
    end
    assert_redirected_to owned_rice_prices_path

    @owned_rice_price.reload
    assert_equal new_owned_rice_price[:work_type_id], @owned_rice_price.work_type_id
    assert_equal new_owned_rice_price[:display_order], @owned_rice_price.display_order
    assert_equal new_owned_rice_price[:name], @owned_rice_price.name
    assert_equal new_owned_rice_price[:short_name], @owned_rice_price.short_name
    assert_equal new_owned_rice_price[:owned_price], @owned_rice_price.owned_price
  end

  test "保有米単価マスタ削除" do
    assert_difference('OwnedRicePrice.count', -1) do
      delete owned_rice_price_path(@owned_rice_price.id)
    end
    assert_redirected_to owned_rice_prices_path

    assert_nil OwnedRicePrice.find_by(id: @owned_rice_price.id)
  end
end
