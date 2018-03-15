require 'test_helper'

class SectionsControllerTest < ActionController::TestCase
  setup do
    @request = ActionController::TestRequest.new
    @request.instance_eval do
      def remote_ip
        "127.0.0.1"
      end
    end
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
      post :create, section: @update
    end
    assert_redirected_to sections_path
  end

  test "班マスタ変更(表示)" do
    get :edit, id: @section
    assert_response :success
  end

  test "班マスタ変更(実行)" do
    assert_no_difference('Section.count') do
      patch :update, id: @section, section: @update
    end
    assert_redirected_to sections_path
  end

  test "班マスタ削除" do
    assert_difference('Section.count', -1) do
      delete :destroy, id: @section
    end
    assert_redirected_to sections_path
  end
end
