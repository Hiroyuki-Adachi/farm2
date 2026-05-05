require 'test_helper'

class HomesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @home = homes(:home1)
    @update = { name: "試験", phonetic: "しけん", section_id: 1, member_flag: true, display_order: 99 }
  end

  test "世帯マスタ一覧" do
    get homes_path
    assert_response :success
  end

  test "世帯マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get homes_path
    assert_response :error
  end

  test "世帯マスタ新規作成(表示)" do
    get new_home_path
    assert_response :success
  end

  test "世帯マスタ新規作成(実行)" do
    assert_difference('Home.count') do
      post homes_path, params: { home: @update }
    end
    assert_redirected_to homes_path

    home = Home.last
    assert_equal @update[:name], home.name
    assert_equal @update[:phonetic], home.phonetic
    assert_equal @update[:section_id], home.section_id
    assert_equal @update[:member_flag], home.member_flag
    assert_equal @update[:display_order], home.display_order
  end

  test "世帯マスタ変更(表示)" do
    get edit_home_path(@home)
    assert_response :success
  end

  test "世帯マスタ変更(表示)(戻り先を保持)" do
    get edit_home_path(@home, return_to: homes_path(page: 2))

    assert_response :success
    assert_select "input[type=hidden][name=return_to][value=?]", homes_path(page: 2), 1
    assert_select "a[href=?]", homes_path(page: 2), text: "戻る"
  end

  test "別組織の世帯マスタ変更(表示)" do
    get edit_home_path(homes(:home_other_org))
    assert_response :error
  end

  test "世帯マスタ変更(実行)" do
    assert_no_difference('Home.count') do
      patch home_path(@home), params: { home: @update }
    end
    assert_redirected_to homes_path

    @home.reload
    assert_equal @update[:name], @home.name
    assert_equal @update[:phonetic], @home.phonetic
    assert_equal @update[:section_id], @home.section_id
    assert_equal @update[:member_flag], @home.member_flag
    assert_equal @update[:display_order], @home.display_order
  end

  test "世帯マスタ変更(実行)(元のページへ戻る)" do
    assert_no_difference('Home.count') do
      patch home_path(@home), params: { home: @update, return_to: homes_path(page: 2) }
    end
    assert_redirected_to homes_path(page: 2)
  end

  test "世帯マスタ変更(実行)(不正な戻り先は一覧へ戻る)" do
    assert_no_difference('Home.count') do
      patch home_path(@home), params: { home: @update, return_to: "https://example.com/" }
    end
    assert_redirected_to homes_path
  end

  test "世帯マスタ削除" do
    assert_difference('Home.kept.count', -1) do
      delete home_path(@home)
    end
    assert_redirected_to homes_path

    assert_nil Home.kept.find_by(id: @home.id)
  end
end
