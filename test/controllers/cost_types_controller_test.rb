require "test_helper"

class CostTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @cost_type = cost_types(:cost_types1)
    @work_kind = work_kinds(:work_kinds1)
    @update = { name: "試験", phonetic: "しけん", display_order: 99, work_kind_ids: [@work_kind.id] }
  end

  test "原価種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "原価原価(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "原価種別マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "原価種別マスタ新規作成(実行)" do
    assert_no_difference('WorkKind.count') do
      assert_difference('CostType.count') do
        post :create, params: {cost_type: @update}
      end
    end
    assert_redirected_to cost_types_path
    assert_not_nil WorkKind.find(@work_kind.id).cost_type_id
  end

  test "原価種別マスタ変更(表示)" do
    get :edit, params: {id: @cost_type}
    assert_response :success
  end

  test "原価種別マスタ変更(実行)" do
    assert_no_difference('WorkKind.count') do
      assert_no_difference('CostType.count') do
        patch :update, params: {id: @cost_type, cost_type: @update}
      end
    end
    assert_redirected_to cost_types_path
    assert_equal @cost_type.id, WorkKind.find(@work_kind.id).cost_type_id
  end

  test "原価種別マスタ削除" do
    assert_no_difference('WorkKind.count') do
      assert_difference('CostType.count', -1) do
        delete :destroy, params: {id: @cost_type}
      end
    end
    assert_redirected_to cost_types_path

    assert_nil WorkKind.find(@work_kind.id).cost_type_id
  end
end
