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
        manage_fee: 30_000,
        peasant_fee: 40_000,
        term: 2015,
        id: nil,
        land_id: land_genka2.id
      }
    }
    assert_difference('LandFee.count') do
      patch lands_fee_path(id: @home_id), params: { land_fees: update }
    end
    assert_redirected_to lands_fees_path

    land_fee = LandFee.last
    assert_equal update[land_genka2.id][:manage_fee], land_fee.manage_fee
    assert_equal update[land_genka2.id][:peasant_fee], land_fee.peasant_fee
    assert_equal update[land_genka2.id][:term], land_fee.term
    assert_equal update[land_genka2.id][:land_id], land_fee.land_id
  end

  test "他組織の土地には土地料金を作成しない" do
    other_land = lands(:land_other_org)
    update = {
      other_land.id => {
        manage_fee: 30_000,
        peasant_fee: 40_000,
        term: 2015,
        id: nil,
        land_id: other_land.id
      }
    }

    assert_no_difference("LandFee.count") do
      patch lands_fee_path(id: @home_id), params: { land_fees: update }
    end
    assert_response :not_found
  end

  test "同じ組織でも別世帯の土地料金は更新しない" do
    other_fee = LandFee.create!(land: lands(:lands0), term: 2015, manage_fee: 100, peasant_fee: 200)
    land = lands(:land_genka2)
    update = {
      land.id => {
        manage_fee: 30_000,
        peasant_fee: 40_000,
        term: 2015,
        id: other_fee.id,
        land_id: land.id
      }
    }

    assert_no_changes -> { other_fee.reload.attributes.slice("land_id", "manage_fee", "peasant_fee") } do
      patch lands_fee_path(id: @home_id), params: { land_fees: update }
    end
    assert_response :not_found
  end

  test "土地料金の一括更新に失敗した場合は全件をロールバックする" do
    fee = land_fees(:land_fee1)
    original_manage_fee = fee.manage_fee
    update = {
      fee.land_id => {
        manage_fee: original_manage_fee + 1,
        peasant_fee: fee.peasant_fee,
        term: fee.term,
        id: fee.id,
        land_id: fee.land_id
      },
      lands(:land_other_org).id => {
        manage_fee: 30_000,
        peasant_fee: 40_000,
        term: 2015,
        id: nil,
        land_id: lands(:land_other_org).id
      }
    }

    assert_no_changes -> { fee.reload.manage_fee } do
      patch lands_fee_path(id: @home_id), params: { land_fees: update }
    end
    assert_response :not_found
  end
end
