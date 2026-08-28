require "test_helper"

class MasterOrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @organization = organizations(:org)
    login_as(users(:users1))
  end

  test "マスタ一覧に他組織データを表示しない" do
    get institutions_path
    assert_response :success
    assert_not_includes response.body, institutions(:institution_other_org).name

    get land_places_path
    assert_response :success
    assert_not_includes response.body, land_places(:land_place_other_org).name

    get owned_rice_prices_path
    assert_response :success
    assert_not_includes response.body, owned_rice_prices(:owned_rice_price_other_org).name
  end

  test "新規マスタに現在の組織を設定する" do
    post institutions_path, params: {
      institution: { name: "新施設", start_term: 2015, end_term: 9999, display_order: 99 }
    }
    assert_equal @organization.id, Institution.order(:id).last.organization_id

    post land_places_path, params: {
      land_place: { name: "新場所", display_order: 99, remarks: "テスト" }
    }
    assert_equal @organization.id, LandPlace.order(:id).last.organization_id

    post owned_rice_prices_path, params: {
      owned_rice_price: {
        term: 2015, work_type_id: work_types(:work_types1).id, display_order: 99,
        name: "新単価", short_name: "新米", owned_price: 6500
      }
    }
    assert_equal @organization.id, OwnedRicePrice.order(:id).last.organization_id
  end

  test "他組織マスタを直接更新できない" do
    other_institution = institutions(:institution_other_org)
    patch institution_path(other_institution), params: {
      institution: { name: "変更済", start_term: 2015, end_term: 9999, display_order: 1 }
    }
    assert_response :not_found
    assert_equal "別組織施設", other_institution.reload.name

    other_land_place = land_places(:land_place_other_org)
    patch land_place_path(other_land_place), params: {
      land_place: { name: "変更済", display_order: 1, remarks: "変更" }
    }
    assert_response :not_found
    assert_equal "別組織場所", other_land_place.reload.name

    other_price = owned_rice_prices(:owned_rice_price_other_org)
    patch owned_rice_price_path(other_price), params: {
      owned_rice_price: {
        term: 2015, work_type_id: other_price.work_type_id, display_order: 1,
        name: "変更済", short_name: "変更", owned_price: 1
      }
    }
    assert_response :not_found
    assert_equal "別組織米", other_price.reload.name
  end

  test "清掃施設の候補と更新を現在の組織に限定する" do
    work = works(:work_cleaning)
    other_institution = institutions(:institution_other_org)

    get edit_gaps_cleaning_path(work)
    assert_response :success
    assert_not_includes response.body, other_institution.name

    assert_no_difference("Cleaning.count") do
      put gaps_cleaning_path(work), params: {
        cleaning: { target: "TEST", method: "TEST", institution_ids: [other_institution.id] }
      }
    end
    assert_response :not_found
  end

  test "土地の場所候補と登録を現在の組織に限定する" do
    other_land_place = land_places(:land_place_other_org)

    get new_land_path
    assert_response :success
    assert_select "select#land_land_place_id option[value=?]", other_land_place.id.to_s, false

    home = homes(:home1)
    assert_no_difference("Land.count") do
      post lands_path, params: {
        land: {
          place: "9999", owner_id: home.id, manager_id: home.id, area: 10,
          target_flag: true, land_place_id: other_land_place.id
        }
      }
    end
    assert_response :not_found
  end

  test "保有米単価の候補と登録を現在の組織に限定する" do
    other_price = owned_rice_prices(:owned_rice_price_other_org)

    get edit_owned_rice_path(homes(:home1))
    assert_response :success
    assert_not_includes response.body, other_price.name

    owned_rice = owned_rices(:owned_rice1)
    assert_no_changes -> { owned_rice.reload.owned_count } do
      patch owned_rice_path(homes(:home1)), params: {
        owned_rices: {
          other_price.id => {
            id: owned_rice.id, home_id: homes(:home1).id,
            owned_rice_price_id: other_price.id, owned_count: 99
          }
        }
      }
    end
    assert_response :not_found
  end
end
