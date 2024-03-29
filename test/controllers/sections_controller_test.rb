require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @section = sections(:sections1)
    @update = { name: "試験", display_order: 99, work_flag: true }
  end

  test "班マスタ一覧" do
    get :index
    assert_response :success
  end

  test "班マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "班マスタ新規作成(実行)" do
    assert_difference('Section.count') do
      post :create, params: {section: @update}
    end
    assert_redirected_to sections_path
  end

  test "班マスタ変更(表示)" do
    get :edit, params: {id: @section}
    assert_response :success
  end

  test "班マスタ変更(実行)" do
    assert_no_difference('Section.count') do
      patch :update, params: {id: @section, section: @update}
    end
    assert_redirected_to sections_path
  end

  test "班マスタ削除" do
    assert_difference('Section.count', -1) do
      delete :destroy, params: {id: @section}
    end
    assert_redirected_to sections_path
  end
end
