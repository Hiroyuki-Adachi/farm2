require "test_helper"

class CostTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @cost_type = cost_types(:cost_types1)
    @work_kind = work_kinds(:work_kind_shirokaki)
    @update = { name: "試験", phonetic: "しけん", display_order: 99, work_kind_ids: [@work_kind.id] }
  end

  test "原価種別マスタ一覧" do
    get cost_types_path
    assert_response :success
  end

  test "原価原価(管理者以外)" do
    login_as(users(:user_checker))
    get cost_types_path
    assert_response :error
  end

  test "原価種別マスタ新規作成(表示)" do
    get new_cost_type_path
    assert_response :success
  end

  test "原価種別マスタ新規作成(実行)" do
    assert_no_difference('WorkKind.count') do
      assert_difference('CostType.count') do
        post cost_types_path, params: {cost_type: @update}
      end
    end
    assert_redirected_to cost_types_path

    cost_type = CostType.last
    assert_equal @update[:name], cost_type.name
    assert_equal @update[:phonetic], cost_type.phonetic
    assert_equal @update[:display_order], cost_type.display_order

    @work_kind.reload
    assert_not_nil @work_kind.cost_type_id
  end

  test "原価種別マスタ変更(表示)" do
    get edit_cost_type_path(@cost_type)
    assert_response :success
  end

  test "原価種別マスタ変更(実行)" do
    assert_no_difference('WorkKind.count') do
      assert_no_difference('CostType.count') do
        patch cost_type_path(@cost_type), params: {cost_type: @update}
      end
    end
    assert_redirected_to cost_types_path

    @cost_type.reload
    assert_equal @update[:name], @cost_type.name
    assert_equal @update[:phonetic], @cost_type.phonetic
    assert_equal @update[:display_order], @cost_type.display_order

    @work_kind.reload
    assert_equal @cost_type.id, @work_kind.cost_type_id
  end

  test "原価種別マスタ削除" do
    assert_no_difference('WorkKind.count') do
      assert_difference('CostType.count', -1) do
        delete cost_type_path(@cost_type)
      end
    end
    assert_redirected_to cost_types_path

    assert_nil CostType.find_by(id: @cost_type.id)

    @work_kind.reload
    assert_nil @work_kind.cost_type_id
  end
end
