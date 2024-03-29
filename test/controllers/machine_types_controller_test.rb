require 'test_helper'

class MachineTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @machine_type = machine_types(:machine_types1)
    @update = {name: "試験", display_order: 99}
  end

  test "機械種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "機械種別マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "機械種別マスタ新規作成(実行)" do
    assert_difference('MachineType.count') do
      post :create, params: {machine_type: @update}
    end

    assert_redirected_to machine_types_path
  end

  test "機械種別マスタ変更(表示)" do
    get :edit, params: {id: @machine_type}
    assert_response :success
  end

  test "機械種別マスタ変更(実行)" do
    assert_no_difference('MachineType.count') do
      patch :update, params: {id: @machine_type, machine_type: @update}
    end
    assert_redirected_to machine_types_path
  end

  test "機械種別マスタ削除" do
    assert_raise(ActiveRecord::DeleteRestrictionError) do
      delete :destroy, params: {id: @machine_type}
    end
    assert_difference('MachineType.count', -1) do
      delete :destroy, params: {id: machine_types(:machine_types_removable)}
    end
    assert_redirected_to machine_types_path
  end
end
