require "test_helper"

class Works::GenresControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @genre = work_genres(:genre_rice)
    @update = { name: "試験", display_order: 99, work_category_id: work_categories(:category_change).id }
  end

  test "作業ジャンル一覧" do
    get work_genres_path
    assert_response :success
  end

  test "作業ジャンル一覧(管理者以外)" do
    login_as(users(:user_checker))
    get work_genres_path
    assert_response :error
  end

  test "作業ジャンル新規作成(表示)" do
    get new_work_genre_path
    assert_response :success
  end

  test "作業ジャンル新規作成(実行)" do
    assert_difference('WorkGenre.kept.count') do
      post work_genres_path, params: {work_genre: @update}
    end
    assert_redirected_to work_genres_path

    created_genre = WorkGenre.last
    assert_equal @update[:name], created_genre.name
    assert_equal @update[:display_order], created_genre.display_order
    assert_equal @update[:work_category_id], created_genre.work_category_id
  end

  test "作業カテゴリ変更(表示)" do
    get edit_work_genre_path(@genre)
    assert_response :success
  end

  test "作業ジャンル変更(実行)" do
    assert_no_difference('WorkGenre.kept.count') do
      patch work_genre_path(@genre), params: {work_genre: @update}
    end
    assert_redirected_to work_genres_path

    @genre.reload
    assert_equal @update[:name], @genre.name
    assert_equal @update[:display_order], @genre.display_order
    assert_equal @update[:work_category_id], @genre.work_category_id
  end

  test "作業ジャンル削除(データあり)" do
    assert_no_difference('WorkGenre.kept.count') do
      delete work_genre_path(@genre)
    end
    assert_response :unprocessable_content
  end

  test "作業ジャンル削除(データなし)" do
    created_genre = WorkGenre.create!(name: "削除用", display_order: 999, category: work_categories(:category_rice))
    assert_difference('WorkGenre.kept.count', -1) do
      delete work_genre_path(created_genre)
    end
    assert_redirected_to work_genres_path
  end
end
