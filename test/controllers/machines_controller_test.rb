require 'test_helper'

class MachinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @machine = machines(:machines1)
    @update = { 
      name: "試験", display_order: 99, 
      validity_start_at: "2010-01-01", validity_end_at: "2020-12-31", 
      machine_type_id: machine_types(:machine_types0).id, home_id: homes(:home1).id
    }
  end

  test "機械マスタ一覧" do
    get machines_path
    assert_response :success
  end

  test "機械マスタ一覧(検証者以外)" do
    login_as(users(:user_user))
    get machines_path
    assert_response :error
  end

  test "機械マスタ新規作成(表示)" do
    get new_machine_path
    assert_response :success
  end

  test "機械マスタ新規作成(実行)" do
    assert_difference('Machine.count') do
      post machines_path, params: {machine: @update}
    end
    assert_redirected_to machines_path

    machine = Machine.last
    assert_equal @update[:name], machine.name
    assert_equal @update[:display_order], machine.display_order
    assert_equal @update[:validity_start_at], machine.validity_start_at.to_s
    assert_equal @update[:validity_end_at], machine.validity_end_at.to_s
    assert_equal @update[:machine_type_id], machine.machine_type_id
    assert_equal @update[:home_id], machine.home_id
  end

  test "機械マスタ変更(表示)" do
    get edit_machine_path(@machine)
    assert_response :success
  end

  test "機械種別マスタ変更(実行)" do
    assert_no_difference('Machine.count') do
      patch machine_path(@machine), params: {id: @machine, machine: @update}
    end
    assert_redirected_to machines_path

    @machine.reload
    assert_equal @update[:name], @machine.name
    assert_equal @update[:display_order], @machine.display_order
    assert_equal @update[:validity_start_at], @machine.validity_start_at.to_s
    assert_equal @update[:validity_end_at], @machine.validity_end_at.to_s
    assert_equal @update[:machine_type_id], @machine.machine_type_id
    assert_equal @update[:home_id], @machine.home_id
  end

  test "機械種別マスタ削除" do
    assert_difference('Machine.count', -1) do
      delete machine_path(@machine)
    end
    assert_redirected_to machines_path

    assert_nil Machine.find_by(id: @machine.id)
  end
end
