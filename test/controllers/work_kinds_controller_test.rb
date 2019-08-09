require 'test_helper'

class WorkKindsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work_kind = work_kinds(:work_kinds1)
    @term = Organization.first.term
    Organization.first.save_term
    @update = { name: "試験", display_order: 99, price: 1500, land_flag: true }
  end

  test "作業種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "作業種別マスタ一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "作業種別マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "作業種別マスタ新規作成(実行)" do
    assert_difference('WorkKind.count') do
      assert_difference('WorkKindPrice.count') do
        post :create, params: {work_kind: @update}
      end
    end
    assert_redirected_to work_kinds_path
  end

  test "作業種別マスタ変更(表示)" do
    get :edit, params: {id: @work_kind}
    assert_response :success
  end

  test "作業種別マスタ変更(実行)" do
    assert_no_difference('WorkKind.count') do
      patch :update, params: {id: @work_kind, work_kind: @update}
    end
    assert_equal @update[:price], WorkKindPrice.find_by(term: @term, work_kind_id: @work_kind).price
    assert_equal 1, WorkKindPrice.where(work_kind_id: @work_kind, price: @update[:price]).count
    assert_redirected_to work_kinds_path
  end

  test "作業種別マスタ削除" do
    assert_difference('WorkKind.count', -1) do
      delete :destroy, params: {id: @work_kind}
    end
    assert_redirected_to work_kinds_path
  end
end
