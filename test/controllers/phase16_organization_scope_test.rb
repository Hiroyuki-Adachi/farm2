require "test_helper"

class Phase16OrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @other_home = homes(:home_other_org)
    @other_land = lands(:land_other_org)
    login_as(@user)
  end

  test "育苗一覧と集計に他組織の担当世帯を含めない" do
    SeedlingHome.create!(
      seedling: seedlings(:seedling1), home: @other_home, quantity: 10, sowed_on: Date.new(2015, 5, 1)
    )

    get seedling_results_path
    assert_response :success
    assert_not_includes response.body, @other_home.name

    get total_seedlings_path
    assert_response :success
    assert_not_includes response.body, @other_home.name
  end

  test "育苗担当に他組織の世帯を登録できない" do
    attributes = { seedling_homes_attributes: [{ home_id: @other_home.id, quantity: 10 }] }

    assert_no_difference("SeedlingHome.count") do
      patch seedling_cost_path(seedling_id: seedlings(:seedling1).id), params: { seedling: attributes }
    end
    assert_response :not_found
  end

  test "育苗結果に他組織の作業実績を登録できない" do
    attributes = {
      seedling_results_attributes: [{ work_result_id: work_results(:work_result_other_org).id, quantity: 1 }]
    }

    assert_no_difference("SeedlingResult.count") do
      patch seedling_result_path(seedling_home_id: seedling_homes(:seedling_home1).id),
            params: { seedling_home: attributes }
    end
    assert_response :not_found
  end

  test "保有米の空IDは新規登録として扱う" do
    attributes = {
      owned_rice_prices(:owned_rice_price1).id => {
        id: "", home_id: homes(:home2).id,
        owned_rice_price_id: owned_rice_prices(:owned_rice_price1).id, owned_count: 2
      }
    }

    assert_difference("OwnedRice.count") do
      patch owned_rice_path(homes(:home2).id), params: { owned_rices: attributes }
    end
    assert_redirected_to owned_rices_path
  end

  test "保有米更新で他組織のレコードを変更できない" do
    owned_rice = OwnedRice.create!(
      home: @other_home, owned_rice_price: owned_rice_prices(:owned_rice_price1), owned_count: 1
    )
    attributes = {
      owned_rice.id => {
        id: owned_rice.id, home_id: homes(:home1).id,
        owned_rice_price_id: owned_rice_prices(:owned_rice_price1).id, owned_count: 99
      }
    }

    patch owned_rice_path(homes(:home1).id), params: { owned_rices: attributes }

    assert_response :not_found
    assert_equal 1, owned_rice.reload.owned_count
  end

  test "作付計画に他組織の土地を登録できない" do
    login_as(users(:user_manager))
    mode = Plans::LandsController::TERM_MODES[:next]

    travel_to(Date.new(2015, 1, 1)) do
      assert_no_difference("PlanLand.count") do
        post plans_lands_path(mode: mode), params: { land: { @other_land.id => work_types(:work_types1).id } }
      end
      assert_response :not_found
    end
  end

  test "乾燥調整に他組織の土地を登録できない" do
    attributes = { drying_lands_attributes: [{ land_id: @other_land.id, display_order: 1 }] }

    assert_no_difference("DryingLand.count") do
      patch drying_path(dryings(:drying1)), params: { drying: attributes }
    end
    assert_response :not_found
  end

  test "乾燥集計に他組織の世帯を含めない" do
    @other_home.update!(drying_order: 999)

    get total_dryings_path

    assert_response :success
    assert_not_includes response.body, @other_home.name
  end
end
