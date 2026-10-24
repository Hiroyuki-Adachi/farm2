require "test_helper"

class WorkTypeMasterOrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @other_organization = organizations(:org2)
    @other_category = WorkCategory.create!(organization: @other_organization, name: "別組織区分", display_order: 1)
    @other_genre = WorkGenre.create!(category: @other_category, name: "別組織種類", display_order: 1)
    @other_work_type = WorkType.create!(genre: @other_genre, name: "別組織分類", display_order: 1)
  end

  test "保守画面の一覧に他組織の作業分類マスタを表示しない" do
    get work_categories_path
    assert_response :success
    assert_includes response.body, work_categories(:category_rice).name
    assert_not_includes response.body, @other_category.name

    get work_genres_path
    assert_response :success
    assert_includes response.body, work_genres(:genre_rice).name
    assert_not_includes response.body, @other_genre.name

    get work_types_path
    assert_response :success
    assert_includes response.body, work_types(:work_type_koshi).name
    assert_not_includes response.body, @other_work_type.name
  end

  test "保守画面のフォームの選択肢に他組織の親マスタを表示しない" do
    get new_work_genre_path
    assert_response :success
    assert_select "select#work_genre_work_category_id option[value='#{work_categories(:category_rice).id}']"
    assert_select "select#work_genre_work_category_id option[value='#{@other_category.id}']", count: 0

    get new_work_type_path
    assert_response :success
    assert_select "select#work_type_work_genre_id option[value='#{work_genres(:genre_rice).id}']"
    assert_select "select#work_type_work_genre_id option[value='#{@other_genre.id}']", count: 0
  end

  test "他組織の作業カテゴリを直接編集・更新・削除できない" do
    get edit_work_category_path(@other_category)
    assert_response :not_found

    patch work_category_path(@other_category), params: { work_category: { name: "変更済", display_order: 1 } }
    assert_response :not_found
    assert_equal "別組織区分", @other_category.reload.name

    assert_no_difference("WorkCategory.count") do
      delete work_category_path(@other_category)
    end
    assert_response :not_found
  end

  test "他組織の作業ジャンルを直接編集・更新・削除できない" do
    get edit_work_genre_path(@other_genre)
    assert_response :not_found

    patch work_genre_path(@other_genre), params: { work_genre: { name: "変更済", display_order: 1 } }
    assert_response :not_found
    assert_equal "別組織種類", @other_genre.reload.name

    assert_no_difference("WorkGenre.count") do
      delete work_genre_path(@other_genre)
    end
    assert_response :not_found
  end

  test "他組織の作業分類を直接編集・更新・削除できない" do
    get edit_work_type_path(@other_work_type)
    assert_response :not_found

    patch work_type_path(@other_work_type), params: { work_type: { name: "変更済", display_order: 1 } }
    assert_response :not_found
    assert_equal "別組織分類", @other_work_type.reload.name

    delete work_type_path(@other_work_type)
    assert_response :not_found
    assert_not @other_work_type.reload.discarded?
  end

  test "他組織の作業カテゴリを親にした作業ジャンルは登録できない" do
    assert_no_difference("WorkGenre.count") do
      post work_genres_path, params: {
        work_genre: { name: "不一致", display_order: 1, work_category_id: @other_category.id }
      }
    end
    assert_response :unprocessable_content
  end

  test "他組織の作業ジャンルを親にした作業分類は登録できない" do
    assert_no_difference("WorkType.count") do
      post work_types_path, params: { work_type: { name: "不一致", display_order: 1, work_genre_id: @other_genre.id } }
    end
    assert_response :unprocessable_content
  end

  test "組織設定の作業分類の選択肢に他組織の作業分類を表示しない" do
    organization = organizations(:org)
    get edit_organization_path(organization)
    assert_response :success
    assert_select "select#organization_broccoli_work_type_id option[value='#{@other_work_type.id}']", count: 0
    assert_select "select#organization_contract_work_type_id option[value='#{@other_work_type.id}']", count: 0
  end

  test "組織設定に他組織の作業分類を設定できない" do
    organization = organizations(:org)
    before_broccoli = organization.broccoli_work_type_id
    before_contract = organization.contract_work_type_id

    patch organization_path(organization), params: {
      organization: { broccoli_work_type_id: @other_work_type.id, contract_work_type_id: @other_work_type.id }
    }
    assert_response :unprocessable_content

    organization.reload
    assert_equal before_broccoli, organization.broccoli_work_type_id
    assert_equal before_contract, organization.contract_work_type_id
  end
end
