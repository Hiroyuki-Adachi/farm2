require 'test_helper'

class WorkTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work_type = work_types(:work_type_koshi)
    @update = { name: "試験", display_order: 99, genre: 1 }
  end

  test "作業分類マスタ一覧" do
    get :index
    assert_response :success
  end

  test "作業分類マスタ一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "作業分類マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "作業分類マスタ新規作成(実行)" do
    assert_difference('WorkType.count') do
      post :create, params: {work_type: @update}
    end
    assert_redirected_to work_types_path

    # 作成した作業分類を検証
    work_type = WorkType.last
    assert_equal @update[:name], work_type.name
    assert_equal @update[:display_order], work_type.display_order
    assert_equal @update[:genre], work_type.genre
  end

  test "作業分類マスタ変更(表示)" do
    get :edit, params: {id: @work_type}
    assert_response :success
  end

  test "作業分類マスタ変更(実行)" do
    assert_no_difference('WorkType.count') do
      patch :update, params: {id: @work_type, work_type: @update}
    end
    assert_redirected_to work_types_path

    # 更新した作業分類を検証
    work_type = WorkType.find(@work_type.id)
    assert_equal @update[:name], work_type.name
    assert_equal @update[:display_order], work_type.display_order
    assert_equal @update[:genre], work_type.genre
  end

  test "作業分類マスタ削除" do
    assert_difference('WorkType.count', -1) do
      delete :destroy, params: {id: @work_type}
    end
    assert_redirected_to work_types_path
  end
end
