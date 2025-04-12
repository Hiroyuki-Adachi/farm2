require 'test_helper'

class OwnedRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @home = homes(:home1)
    @owned_rice_price = owned_rice_prices(:owned_rice_price1)
    @owned_rice = owned_rices(:owned_rice1)
  end

  test "保有米一覧" do
    get owned_rices_path
    assert_response :success
  end

  test "保有米一覧(管理者以外)" do
    login_as(users(:user_checker))
    get owned_rices_path
    assert_response :error
  end

  test "保有米変更(表示)" do
    get edit_owned_rice_path(@home.id)
    assert_response :success
  end

  test "保有米変更(実行)" do
    new_owned_rice = {@owned_rice_price.id => {
      home_id: @home.id, owned_rice_price_id: @owned_rice_price.id, id: @owned_rice.id,
      owned_count: 20
    }}
    assert_no_difference('OwnedRice.count') do
      patch owned_rice_path(@home.id), params: {owned_rices: new_owned_rice}
    end
    assert_redirected_to owned_rices_path

    @owned_rice.reload
    assert_equal new_owned_rice[@owned_rice_price.id][:owned_count], @owned_rice.owned_count
  end

  test "保有米作成(実行)" do
    new_home = homes(:home2)
    new_owned_rice = {@owned_rice_price.id => {
      home_id: new_home.id, owned_rice_price_id: @owned_rice_price.id,
      owned_count: 5
    }}
    assert_difference('OwnedRice.count') do
      patch owned_rice_path(new_home.id), params: {owned_rices: new_owned_rice}
    end
    assert_redirected_to owned_rices_path

    owned_rice = OwnedRice.last
    assert_equal new_owned_rice[@owned_rice_price.id][:owned_count], owned_rice.owned_count
    assert_equal new_home.id, owned_rice.home_id
    assert_equal @owned_rice_price.id, owned_rice.owned_rice_price_id
  end
end
