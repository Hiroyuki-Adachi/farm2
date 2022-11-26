require "test_helper"

class InstitutionsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @institution = institutions(:kakunoko)
    @update = {
      name: "第二格納庫",
      start_term: 2016,
      end_term: 9999,
      display_order: 3
    }
  end

  test "施設マスタ一覧" do
    get :index
    assert_response :success
  end

  test "施設マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "施設マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "施設マスタ新規作成(実行)" do
    assert_difference('Institution.count') do
      post :create, params: {institution: @update}
    end

    assert_redirected_to institutions_path
  end

  test "施設マスタ変更(表示)" do
    get :edit, params: {id: @institution}
    assert_response :success
  end

  test "施設マスタ変更(実行)" do
    assert_no_difference('Institution.count') do
      patch :update, params: {id: @institution, institution: @update}
    end
    assert_redirected_to institutions_path
  end

  test "施設マスタ削除" do
    assert_difference('Institution.count', -1) do
      delete :destroy, params: {id: @institution}
    end
    assert_redirected_to institutions_path
  end
end
