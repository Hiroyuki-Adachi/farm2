require "test_helper"

class Lands::FeesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @home_id = 5
  end

  test "土地原価一覧" do
    get lands_fees_path
    assert_response :success
  end

  test "土地原価一覧(管理者以外)" do
    login_as(users(:user_checker))
    get lands_fees_path
    assert_response :error
  end

  test "土地原価変更(表示)" do
    get edit_lands_fee_path(id: @home_id)
    assert_response :success
  end

  test "土地原価変更(実行)" do
    land_genka2 = lands(:land_genka2)
    update = {
      land_genka2.id => {
        manage_fee: 30000,
        peasant_fee: 40000,
        term: 2015,
        id: nil,
        land_id: land_genka2.id
      }
    }
    assert_difference('LandFee.count') do
      patch lands_fee_path(id: @home_id), params: {land_fees: update}
    end
    assert_redirected_to lands_fees_path

    land_fee = LandFee.last
    assert_equal update[land_genka2.id][:manage_fee], land_fee.manage_fee
    assert_equal update[land_genka2.id][:peasant_fee], land_fee.peasant_fee
    assert_equal update[land_genka2.id][:term], land_fee.term
    assert_equal update[land_genka2.id][:land_id], land_fee.land_id
  end
end
