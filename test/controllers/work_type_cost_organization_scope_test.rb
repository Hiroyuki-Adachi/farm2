require "test_helper"

class WorkTypeCostOrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    travel_to(Date.new(2015, 1, 1))
    other_organization = organizations(:org2)
    @other_category = WorkCategory.create!(organization: other_organization, name: "別組織区分", display_order: 1)
    @other_genre = WorkGenre.create!(category: @other_category, name: "別組織種類", display_order: 1)
    @other_work_type = WorkType.create!(
      genre: @other_genre, name: "別組織分類", display_order: 1, land_flag: true, work_flag: true
    )
    [2015, 2016].each do |term|
      WorkTypeTerm.create!(term: term, work_type: @other_work_type, bg_color: "#123456")
    end
    @user = users(:users1)
    login_as(@user)
  end

  teardown do
    travel_back
  end

  test "原価の画面に他組織の作業分類を表示しない" do
    [
      total_costs_path, total_costs_machines_path, land_costs_path, map_land_costs_path,
      machine_reserve_fund_costs_path, chemical_costs_path, seedling_costs_path, fuel_costs_path,
      owned_rice_prices_path, work_seedlings_path
    ].each do |path|
      get path
      assert_response :success, path
      assert_not_includes response.body, @other_work_type.name, path
    end
  end

  test "土地原価の作業分類の選択肢に他組織の作業分類を表示しない" do
    get work_types_land_costs_path, params: { index: 0, date: "2015-01-01" }, as: :turbo_stream
    assert_response :success
    assert_select "input#work_type_0_#{@other_work_type.id}", count: 0
  end

  test "ソリマチの作業分類に他組織の作業分類を表示しない" do
    get edit_sorimachi_work_type_path(sorimachi_journal_id: sorimachi_journals(:journal1).id)
    assert_response :success
    assert_not_includes response.body, @other_work_type.name

    get sorimachi_imports_path
    assert_response :success
    assert_not_includes response.body, @other_work_type.name
  end

  test "個人情報の地図に他組織の作業分類を表示しない" do
    get personal_information_maps_path(personal_information_token: @user.token)
    assert_response :success
    assert_not_includes response.body, @other_work_type.name
  end

  test "統計の作業ジャンルに他組織の作業ジャンルを表示しない" do
    get tab2_statistics_path(format: :json)
    assert_response :success
    assert_not_includes response.body, @other_genre.name
  end

  test "作業種別の作業カテゴリに他組織のカテゴリを表示せず登録もできない" do
    work_kind = work_kinds(:work_kind_taue)

    get edit_work_kind_path(work_kind)
    assert_response :success
    assert_select "input#work_category_#{@other_category.id}", count: 0

    patch work_kind_path(work_kind), params: {
      work_kind: { name: "変更後" }, work_categories: [@other_category.id]
    }
    assert_response :not_found
    assert_not_includes work_kind.reload.categories, @other_category
    assert_not_equal "変更後", work_kind.name

    assert_no_difference("WorkKind.count") do
      post work_kinds_path, params: {
        work_kind: { name: "新規作業種別", phonetic: "しんき", display_order: 99, price: 1500, land_flag: true },
        work_categories: [@other_category.id]
      }
    end
    assert_response :not_found
  end

  test "作業種別の作業カテゴリを更新しても他組織のカテゴリとの対応は残す" do
    work_kind = work_kinds(:work_kind_taue)
    WorkKindType.create!(work_kind: work_kind, category: @other_category)
    category = work_categories(:category_rice)

    patch work_kind_path(work_kind), params: { work_kind: { name: work_kind.name }, work_categories: [category.id] }

    assert_includes work_kind.reload.categories, @other_category
    assert_includes work_kind.categories, category
  end
end
