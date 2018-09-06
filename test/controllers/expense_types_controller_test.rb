require 'test_helper'

class ExpenseTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @expense_type = expense_types(:expense_type2)
    @update = {name: "名前更新", sales_flag: true, display_order: 99}
  end

  test "経費種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "経費種別マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "経費種別マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "経費種別マスタ新規作成(実行)" do
    assert_difference('ExpenseType.count') do
      post :create, params: {expense_type: @update}
    end

    assert_redirected_to expense_types_path
  end

  test "経費種別マスタ変更(表示)" do
    get :edit, params: {id: @expense_type}
    assert_response :success
  end

  test "経費種別マスタ変更(実行)" do
    assert_no_difference('ExpenseType.count') do
      patch :update, params: {id: @expense_type, expense_type: @update}
    end
    assert_redirected_to expense_types_path
  end

  test "経費種別マスタ削除" do
    assert_difference('ExpenseType.count', -1) do
      delete :destroy, params: {id: @expense_type}
    end
    assert_redirected_to expense_types_path
  end
end
