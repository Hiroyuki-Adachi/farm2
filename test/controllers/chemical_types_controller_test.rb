require 'test_helper'

class ChemicalTypesControllerTest < ActionController::TestCase
  setup do
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
      post :create, chemical_type: @update
    end

    assert_redirected_to chemical_types_path
  end

  test "薬剤種別マスタ変更(表示)" do
    get :edit, id: @chemical_type
    assert_response :success
  end

  test "薬剤種別マスタ変更(実行)" do
    patch :update, id: @chemical_type, chemical_type: @update
    assert_redirected_to chemical_types_path
  end

  test "薬剤種別マスタ削除" do
    assert_difference('ChemicalType.count', -1) do
      delete :destroy, id: @chemical_type
    end
    assert_redirected_to chemical_types_path
  end
end
