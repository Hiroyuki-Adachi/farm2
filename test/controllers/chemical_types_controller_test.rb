require 'test_helper'

class ChemicalTypesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @chemical_type = chemical_types(:chemical_types0)
    @update = { name: "試験", display_order: 99 }
  end

  test "薬剤種別マスタ一覧" do
    get chemical_types_path
    assert_response :success
  end

  test "薬剤種別マスタ新規作成(表示)" do
    get new_chemical_type_path
    assert_response :success
  end

  test "薬剤種別マスタ新規作成(実行)" do
    assert_difference('ChemicalType.count') do
      post chemical_types_path, params: {chemical_type: @update}
    end
    assert_redirected_to chemical_types_path

    # 薬剤種別の検証
    chemical_type = ChemicalType.last
    assert_equal @update[:name], chemical_type.name
    assert_equal @update[:display_order], chemical_type.display_order
  end

  test "薬剤種別マスタ変更(表示)" do
    get edit_chemical_type_path(@chemical_type)
    assert_response :success
  end

  test "薬剤種別マスタ変更(実行)" do
    assert_no_difference('ChemicalType.count') do
      patch chemical_type_path(@chemical_type), params: {chemical_type: @update}
    end
    assert_redirected_to chemical_types_path

    # 薬剤種別の検証
    @chemical_type.reload
    assert_equal @update[:name], @chemical_type.name
    assert_equal @update[:display_order], @chemical_type.display_order
  end

  test "薬剤種別マスタ削除" do
    assert_raise(ActiveRecord::DeleteRestrictionError) do
      delete chemical_type_path(@chemical_type)
    end

    chemical_type = chemical_types(:chemical_type_empty)
    assert_difference('ChemicalType.count', -1) do
      delete chemical_type_path(chemical_type)
    end
    assert_redirected_to chemical_types_path
    assert_nil ChemicalType.find_by(id: chemical_type.id)
  end
end
