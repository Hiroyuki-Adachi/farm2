require "test_helper"

class Works::CategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @category = work_categories(:category_rice)
    @update = { name: "試験", display_order: 99}
  end

  test "作業カテゴリ一覧" do
    get work_categories_path
    assert_response :success
  end

  test "作業カテゴリ一覧(管理者以外)" do
    login_as(users(:user_checker))
    get work_categories_path
    assert_response :error
  end

  test "作業カテゴリ新規作成(表示)" do
    get new_work_category_path
    assert_response :success
  end

  test "作業カテゴリ新規作成(実行)" do
    assert_difference('WorkCategory.kept.count') do
      post work_categories_path, params: {work_category: @update}
    end
    assert_redirected_to work_categories_path

    created_category = WorkCategory.last
    assert_equal @update[:name], created_category.name
    assert_equal @update[:display_order], created_category.display_order
  end

  test "作業カテゴリ変更(表示)" do
    get edit_work_category_path(@category)
    assert_response :success
  end

  test "作業カテゴリ変更(実行)" do
    assert_no_difference('WorkCategory.kept.count') do
      patch work_category_path(@category), params: {work_category: @update}
    end
    assert_redirected_to work_categories_path

    @category.reload
    assert_equal @update[:name], @category.name
    assert_equal @update[:display_order], @category.display_order
  end

  test "作業カテゴリ削除(データあり)" do
    assert_no_difference('WorkCategory.kept.count') do
      delete work_category_path(@category)
    end
    assert_response :unprocessable_content
  end

  test "作業カテゴリ削除(データなし)" do
    created_category = WorkCategory.create!(name: "削除用", display_order: 999)
    assert_difference('WorkCategory.kept.count', -1) do
      delete work_category_path(created_category)
    end
    assert_redirected_to work_categories_path
  end
end
