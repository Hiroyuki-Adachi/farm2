require 'test_helper'

class MachineTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @machine_type = machine_types(:machine_types1)
    @update = {name: "試験", display_order: 99}
  end

  test "機械種別マスタ一覧" do
    get machine_types_path
    assert_response :success
  end

  test "機械種別マスタ新規作成(表示)" do
    get new_machine_type_path
    assert_response :success
  end

  test "機械種別マスタ新規作成(実行)" do
    assert_difference('MachineType.count') do
      post machine_types_path, params: {machine_type: @update}
    end
    assert_redirected_to machine_types_path

    machine_type = MachineType.last
    assert_equal @update[:name], machine_type.name
    assert_equal @update[:display_order], machine_type.display_order
  end

  test "機械種別マスタ変更(表示)" do
    get edit_machine_type_path(@machine_type)
    assert_response :success
  end

  test "機械種別マスタ変更(実行)" do
    assert_no_difference('MachineType.count') do
      patch machine_type_path(@machine_type), params: {machine_type: @update}
    end
    assert_redirected_to machine_types_path

    @machine_type.reload
    assert_equal @update[:name], @machine_type.name
    assert_equal @update[:display_order], @machine_type.display_order
  end

  test "機械種別マスタ削除" do
    assert_raise(ActiveRecord::DeleteRestrictionError) do
      delete machine_type_path(@machine_type)
    end

    delete_machine_type = machine_types(:machine_types_removable)
    assert_difference('MachineType.count', -1) do
      delete machine_type_path(delete_machine_type)
    end
    assert_redirected_to machine_types_path

    assert_nil MachineType.find_by(id: delete_machine_type.id)
  end
end
