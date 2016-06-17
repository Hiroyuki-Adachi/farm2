require 'test_helper'

class WorkersControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:worker1)
    @update = { 
        family_name: "試験", first_name: "太郎", family_phonetic: "しけん", first_phonetic: "たろう",
        home_id: Home.first, display_order: 99 
    }
  end

  test "作業者マスタ一覧" do
    get :index
    assert_response :success
  end

  test "作業者マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "作業者マスタ新規作成(実行)" do
    assert_difference('Worker.count') do
      post :create, worker: @update
    end

    assert_redirected_to workers_path
  end

  test "作業者マスタ変更(表示)" do
    get :edit, id: @worker
    assert_response :success
  end

  test "作業者マスタ変更(実行)" do
    assert_no_difference('Worker.count') do
      patch :update, id: @worker, worker: @update
    end
    assert_redirected_to workers_path
  end

  test "作業者マスタ削除" do
    assert_difference('Worker.count', -1) do
      delete :destroy, id: @worker
    end
    assert_redirected_to workers_path
  end
end
