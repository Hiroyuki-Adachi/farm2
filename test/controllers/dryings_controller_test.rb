require 'test_helper'

class DryingsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "乾燥一覧" do
    get :index
    assert_response :success
  end

  test "乾燥一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "乾燥作成" do
    assert_difference('Drying.count') do
      post :create, params: {drying: {
        term: systems(:s2015).term, 
        carried_on: works(:work_harvest1).worked_at, 
        home_id: homes(:home5).id
      }}
    end
    assert_redirected_to dryings_path
  end

  test "乾燥照会" do
    get :show, params: {id: homes(:home31).id}
    assert_response :success
  end

  test "乾燥編集" do
    get :edit, params: {id: dryings(:drying1).id}
    assert_response :success
  end

  test "乾燥削除" do
    assert_difference('Adjustment.count', -1) do
      assert_difference('Drying.count', -1) do
        delete :destroy, params: {id: dryings(:drying2).id}
      end
    end
    assert_redirected_to dryings_path
  end
end
