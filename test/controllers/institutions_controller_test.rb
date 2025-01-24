require "test_helper"

class InstitutionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @institution = institutions(:kakunoko)
    @update = {
      name: "第二格納庫",
      start_term: 2016,
      end_term: 9999,
      display_order: 3
    }
  end

  test "施設マスタ一覧" do
    get institutions_path
    assert_response :success
  end

  test "施設マスタ一覧(管理者以外)" do
    login_as(users(:user_checker))
    get institutions_path
    assert_response :error
  end

  test "施設マスタ新規作成(表示)" do
    get new_institution_path
    assert_response :success
  end

  test "施設マスタ新規作成(実行)" do
    assert_difference('Institution.count') do
      post institutions_path, params: {institution: @update}
    end
    assert_redirected_to institutions_path

    institution = Institution.last
    assert_equal @update[:name], institution.name
    assert_equal @update[:start_term], institution.start_term
    assert_equal @update[:end_term], institution.end_term
    assert_equal @update[:display_order], institution.display_order
  end

  test "施設マスタ変更(表示)" do
    get edit_institution_path(@institution.id)
    assert_response :success
  end

  test "施設マスタ変更(実行)" do
    assert_no_difference('Institution.count') do
      patch institution_path(@institution.id), params: {institution: @update}
    end
    assert_redirected_to institutions_path

    @institution.reload
    assert_equal @update[:name], @institution.name
    assert_equal @update[:start_term], @institution.start_term
    assert_equal @update[:end_term], @institution.end_term
    assert_equal @update[:display_order], @institution.display_order
  end

  test "施設マスタ削除" do
    assert_difference('Institution.count', -1) do
      delete institution_path(@institution.id)
    end
    assert_redirected_to institutions_path

    assert_nil Institution.find_by(id: @institution.id)
  end
end
