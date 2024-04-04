require "test_helper"

class Chemicals::StoresControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end
    
  test "農薬納品一覧" do
    get :index
    assert_response :success
  end

  test "農薬納品一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "農薬納品新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "農薬納品新規作成(実行)" do
    assert_difference('ChemicalInventory.count') do
      post :create, params: {chemical_inventory: {checked_on: '2015-01-10', name: "当初納品"}}
    end
    assert_redirected_to edit_chemicals_store_path(ChemicalInventory.last)
  end

  test "農薬納品編集(表示)" do
    get :edit, params: {id: chemical_inventories(:store1).id}
    assert_response :success
  end

  test "農薬納品編集(実行)" do
    assert_no_difference('ChemicalInventory.count') do
      patch :update, params: {
        id: chemical_inventories(:store1).id,
        chemical_inventory: {
          checked_on: '2015-12-01',
          name: "期末納品",
          stocks_attributes: [
            {chemical_id: 4, stored_stock: 100.2}
          ]
        }
      }
    end
    assert_redirected_to edit_chemicals_store_path(chemical_inventories(:store1))
    assert_equal 100.2, ChemicalStock.find_by(chemical_inventory_id: chemical_inventories(:store1).id, chemical_id: 4).stored_stock
  end

  test "農薬納品編集(削除)" do
    assert_difference('ChemicalStock.count', -1) do
      assert_difference('ChemicalInventory.count', -1) do
        delete :destroy, params: {id: chemical_inventories(:store1).id}
      end
    end
    assert_redirected_to chemicals_stores_path
  end
end
