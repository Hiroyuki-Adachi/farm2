require 'test_helper'

class WorkTypesControllerTest < ActionController::TestCase
  setup do
    @work_type = work_types(:work_type_koshi)
    @update = { name: "試験", display_order: 99, genre: 1 }
  end

  test "作業分類マスタ一覧" do
    get :index
    assert_response :success
  end

  test "作業分類マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "作業分類マスタ新規作成(実行)" do
    assert_difference('WorkType.count') do
      post :create, work_type: @update
    end
    assert_redirected_to work_types_path
  end

  test "作業分類マスタ変更(表示)" do
    get :edit, id: @work_type
    assert_response :success
  end

  test "作業分類マスタ変更(実行)" do
    assert_no_difference('WorkType.count') do
      patch :update, id: @work_type, work_type: @update
    end
    assert_redirected_to work_types_path
  end

  test "作業分類マスタ削除" do
    assert_difference('WorkType.count', -1) do
      delete :destroy, id: @work_type
    end
    assert_redirected_to work_types_path
  end
end
