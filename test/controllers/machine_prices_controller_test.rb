require 'test_helper'

class MachinePricesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @machine_price_t = machine_price_headers(:machine_price_header_t)
    @machine_price_m = machine_price_headers(:machine_price_header_m)
    @price_detail = {1 => {0 => {adjust_id: 1, price: 500}}}
  end

  test "機械使用料マスタ一覧" do
    get :index, params: {id: @machine_price_t.id}
    assert_response :success
  end

  test "機械使用料照会" do
    get :show_type, params: {machine_type_id: @machine_price_t.machine_type_id}
    assert_response :success

    get :show_machine, params: {machine_id: @machine_price_m.machine_id}
    assert_response :success
  end

  test "機械使用料新規作成(表示)" do
    get :new, params: {machine_type_id: machine_types(:machine_types3)}
    assert_response :success

    get :new, params: {machine_id: machines(:machines3)}
    assert_response :success
  end

  test "機械使用料新規作成(実行)" do
    assert_difference('MachinePriceDetail.count') do
      assert_difference('MachinePriceHeader.count') do
        post :create, params: {machine_price_header: {machine_type_id: @machine_price_t.machine_type_id, validated_at: "2010-01-01"}, details_form: @price_detail}
      end
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    assert_difference('MachinePriceDetail.count') do
      assert_difference('MachinePriceHeader.count') do
        post :create, params: {machine_price_header: {machine_id: @machine_price_m.machine_id, validated_at: "2010-01-01"}, details_form: @price_detail}
      end
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)
  end

  test "機械使用料変更(表示)" do
    get :edit, params: {id: @machine_price_t}
    assert_response :success

    get :edit, params: {id: @machine_price_m}
    assert_response :success
  end

  test "機械使用料変更(実行)" do
    assert_no_difference('MachinePriceDetail.count') do
      assert_no_difference('MachinePriceHeader.count') do
        patch :update, params: {id: @machine_price_t, machine_price_header: {machine_type_id: @machine_price_t.machine_type_id, validated_at: "2010-01-01"}, details_form: @price_detail}
      end
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    assert_no_difference('MachinePriceDetail.count') do
      assert_no_difference('MachinePriceHeader.count') do
        patch :update, params: {id: @machine_price_m, machine_price_header: {machine_id: @machine_price_m.machine_id, validated_at: "2010-01-01"}, details_form: @price_detail}
      end
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)
  end

  test "機械使用料削除" do
    assert_difference('MachinePriceHeader.count', -1) do
      delete :destroy, params: {id: @machine_price_t}
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    assert_difference('MachinePriceHeader.count', -1) do
      delete :destroy, params: {id: @machine_price_m}
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)
  end
end
