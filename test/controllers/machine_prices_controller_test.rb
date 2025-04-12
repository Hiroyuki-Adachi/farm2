require 'test_helper'

class MachinePricesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @machine_price_t = machine_price_headers(:machine_price_header_t)
    @machine_price_m = machine_price_headers(:machine_price_header_m)
    @price_detail = {1 => {0 => {adjust_id: 1, price: 500}}}
  end

  test "機械使用料マスタ一覧" do
    get machine_price_headers_path, params: {id: @machine_price_t.id}
    assert_response :success
  end

  test "機械使用料照会" do
    get show_type_machine_price_headers_path, params: {machine_type_id: @machine_price_t.machine_type_id}
    assert_response :success

    get show_machine_machine_price_headers_path, params: {machine_id: @machine_price_m.machine_id}
    assert_response :success
  end

  test "機械使用料新規作成(表示)" do
    get new_machine_price_header_path, params: {machine_type_id: machine_types(:machine_types3).id}
    assert_response :success

    get new_machine_price_header_path, params: {machine_id: machines(:machines3).id}
    assert_response :success
  end

  test "機械使用料新規作成(実行)(種別)" do
    new_machine_price_header = {machine_type_id: @machine_price_t.machine_type_id, validated_at: "2010-01-01"}
    assert_difference('MachinePriceDetail.count') do
      assert_difference('MachinePriceHeader.count') do
        post machine_price_headers_path, params: {machine_price_header: new_machine_price_header, details_form: @price_detail}
      end
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    machine_price_header = MachinePriceHeader.last
    assert_equal new_machine_price_header[:validated_at], machine_price_header.validated_at.to_s
    assert_equal new_machine_price_header[:machine_type_id], machine_price_header.machine_type_id

    machine_price_detail = MachinePriceDetail.last
    assert_equal machine_price_header.id, machine_price_detail.machine_price_header_id
    assert_equal @price_detail[1][0][:adjust_id], machine_price_detail.adjust_id
    assert_equal @price_detail[1][0][:price], machine_price_detail.price
  end

  test "機械使用料新規作成(実行)(機械)" do
    new_machine_price_header = {machine_id: @machine_price_m.machine_id, validated_at: "2010-01-01"}
    assert_difference('MachinePriceDetail.count') do
      assert_difference('MachinePriceHeader.count') do
        post machine_price_headers_path, params: {machine_price_header: new_machine_price_header, details_form: @price_detail}
      end
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)

    machine_price_header = MachinePriceHeader.last
    assert_equal new_machine_price_header[:validated_at], machine_price_header.validated_at.to_s
    assert_equal new_machine_price_header[:machine_id], machine_price_header.machine_id

    machine_price_detail = MachinePriceDetail.last
    assert_equal machine_price_header.id, machine_price_detail.machine_price_header_id
    assert_equal @price_detail[1][0][:adjust_id], machine_price_detail.adjust_id
    assert_equal @price_detail[1][0][:price], machine_price_detail.price
  end

  test "機械使用料変更(表示)" do
    get edit_machine_price_header_path(@machine_price_t)
    assert_response :success

    get edit_machine_price_header_path(@machine_price_m)
    assert_response :success
  end

  test "機械使用料変更(実行)(種別)" do
    new_machine_price_header = {machine_type_id: @machine_price_t.machine_type_id, validated_at: "2010-01-01"}
    assert_no_difference('MachinePriceDetail.count') do
      assert_no_difference('MachinePriceHeader.count') do
        patch machine_price_header_path(@machine_price_t), params: {machine_price_header: new_machine_price_header, details_form: @price_detail}
      end
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    @machine_price_t.reload
    assert_equal new_machine_price_header[:validated_at], @machine_price_t.validated_at.to_s

    machine_price_detail = @machine_price_t.details.first
    assert_equal @price_detail[1][0][:adjust_id], machine_price_detail.adjust_id
    assert_equal @price_detail[1][0][:price], machine_price_detail.price
  end

  test "機械使用料変更(実行)(機械)" do
    new_machine_price_header = {machine_id: @machine_price_m.machine_id, validated_at: "2010-01-01"}
    assert_no_difference('MachinePriceDetail.count') do
      assert_no_difference('MachinePriceHeader.count') do
        patch machine_price_header_path(@machine_price_m), params: {machine_price_header: new_machine_price_header, details_form: @price_detail}
      end
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)

    @machine_price_m.reload
    assert_equal new_machine_price_header[:validated_at], @machine_price_m.validated_at.to_s

    machine_price_detail = @machine_price_m.details.first
    assert_equal @price_detail[1][0][:adjust_id], machine_price_detail.adjust_id
    assert_equal @price_detail[1][0][:price], machine_price_detail.price
  end

  test "機械使用料削除(種別)" do
    assert_difference('MachinePriceHeader.count', -1) do
      delete machine_price_header_path(@machine_price_t)
    end
    assert_redirected_to show_type_machine_price_headers_path(machine_type_id: @machine_price_t.machine_type_id)

    assert_nil MachinePriceHeader.find_by(id: @machine_price_t.id)
  end

  test "機械使用料削除(機械)" do
    assert_difference('MachinePriceHeader.count', -1) do
      delete machine_price_header_path(@machine_price_m)
    end
    assert_redirected_to show_machine_machine_price_headers_path(machine_id: @machine_price_m.machine_id)

    assert_nil MachinePriceHeader.find_by(id: @machine_price_m.id)
  end
end
