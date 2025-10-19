require 'test_helper'

class WorkTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @work_type = work_types(:work_type_koshi)
    @update = { name: "試験", display_order: 99, work_genre_id: work_genres(:genre_rice).id }
  end

  test "作業分類マスタ一覧" do
    get work_types_path
    assert_response :success
  end

  test "作業分類マスタ一覧(管理者以外)" do
    login_as(users(:user_checker))
    get work_types_path
    assert_response :error
  end

  test "作業分類マスタ新規作成(表示)" do
    get new_work_type_path
    assert_response :success
  end

  test "作業分類マスタ新規作成(実行)" do
    assert_difference('WorkType.kept.count') do
      post work_types_path, params: {work_type: @update}
    end
    assert_redirected_to work_types_path

    # 作成した作業分類を検証
    work_type = WorkType.last
    assert_equal @update[:name], work_type.name
    assert_equal @update[:display_order], work_type.display_order
    assert_equal @update[:genre], work_type.genre
  end

  test "作業分類マスタ変更(表示)" do
    get edit_work_type_path(@work_type)
    assert_response :success
  end

  test "作業分類マスタ変更(実行)" do
    assert_no_difference('WorkType.kept.count') do
      patch work_type_path(@work_type), params: {work_type: @update}
    end
    assert_redirected_to work_types_path

    # 更新した作業分類を検証
    @work_type.reload
    assert_equal @update[:name], @work_type.name
    assert_equal @update[:display_order], @work_type.display_order
    assert_equal @update[:work_genre_id], @work_type.work_genre_id
  end

  test "作業分類マスタ削除" do
    assert_difference('WorkType.kept.count', -1) do
      delete work_type_path(@work_type)
    end
    assert_redirected_to work_types_path

    assert_nil WorkType.kept.find_by(id: @work_type.id)
  end

  test "アイコン" do
    wt = work_types(:work_types_wcs)
    good_v = wt.icon_fingerprint

    get icon_work_type_path(wt, v: good_v)
    assert_response :success
    assert_equal "image/jpeg", @response.media_type

    etag = @response.headers["ETag"]
    get icon_work_type_path(wt, v: good_v), headers: { 'HTTP_IF_NONE_MATCH' => etag }
    assert_response :not_modified

    get icon_work_type_path(wt, v: "OLD")
    assert_response :moved_permanently
    assert_includes @response.headers["Location"], good_v
  end
end
