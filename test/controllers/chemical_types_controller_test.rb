require 'test_helper'

class ChemicalTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @chemical_type = chemical_types(:chemical_types0)
    @update = { name: "試験", display_order: 99 }
  end

  test "薬剤種別マスタ一覧" do
    get :index
    assert_response :success
  end

  test "薬剤種別マスタ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "薬剤種別マスタ新規作成(実行)" do
    assert_difference('ChemicalType.count') do
      post :create, params: {chemical_type: @update}
    end
    assert_redirected_to chemical_types_path

    # 薬剤種別の検証
    chemical_type = ChemicalType.last
    assert_equal @update[:name], chemical_type.name
    assert_equal @update[:display_order], chemical_type.display_order
  end

  test "薬剤種別マスタ変更(表示)" do
    get :edit, params: {id: @chemical_type}
    assert_response :success
  end

  test "薬剤種別マスタ変更(実行)" do
    assert_no_difference('ChemicalType.count') do
      patch :update, params: {id: @chemical_type, chemical_type: @update}
    end
    assert_redirected_to chemical_types_path

    # 薬剤種別の検証
    chemical_type = ChemicalType.find(@chemical_type.id)
    assert_equal @update[:name], chemical_type.name
    assert_equal @update[:display_order], chemical_type.display_order
  end

  test "薬剤種別マスタ削除" do
    assert_raise(ActiveRecord::DeleteRestrictionError) do
      delete :destroy, params: {id: @chemical_type}
    end
    assert_difference('ChemicalType.count', -1) do
      delete :destroy, params: {id: chemical_types(:chemical_type_empty)}
    end
    assert_redirected_to chemical_types_path
  end
end
