require 'test_helper'

class MachinesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @machine = machines(:machines1)
    @update = { 
        name: "試験", display_order: 99, 
        validity_start_at: "2010-01-01", validity_end_at: "2020-12-31", 
        machine_type_id: machine_types(:machine_types0).id, home: homes(:home1).id
    }
  end

  test "機械マスタ一覧" do
    get :index
    assert_response :success
  end

  test "機械マスタ一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "機械マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "機械マスタ新規作成(実行)" do
    assert_difference('Machine.count') do
      post :create, params: {machine: @update}
    end

    assert_redirected_to machines_path
  end

  test "機械マスタ変更(表示)" do
    get :edit, params: {id: @machine}
    assert_response :success
  end

  test "機械種別マスタ変更(実行)" do
    assert_no_difference('Machine.count') do
      patch :update, params: {id: @machine, machine: @update}
    end
    assert_redirected_to machines_path
  end

  test "機械種別マスタ削除" do
    assert_difference('Machine.count', -1) do
      delete :destroy, params: {id: @machine}
    end
    assert_redirected_to machines_path
  end
end
