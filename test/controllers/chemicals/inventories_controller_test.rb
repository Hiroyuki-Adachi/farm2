require "test_helper"

class Chemicals::InventoriesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "農薬棚卸一覧" do
    get :index
    assert_response :success
  end

  test "農薬棚卸一覧(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "農薬棚卸新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "農薬棚卸新規作成(実行)" do
    assert_difference('ChemicalInventory.count') do
      post :create, params: {chemical_inventory: {checked_on: '2015-01-05', name: "当初在庫"}}
    end
    assert_redirected_to edit_chemicals_inventory_path(ChemicalInventory.last)
  end

  test "農薬棚卸編集(表示)" do
    get :edit, params: {id: chemical_inventories(:inventory1).id}
    assert_response :success
  end

  test "農薬棚卸編集(実行)" do
    assert_no_difference('ChemicalInventory.count') do
        patch :update, params: {
            id: chemical_inventories(:inventory1).id,
            chemical_inventory: {
                checked_on: '2015-12-25',
                name: "期末在庫",
                stocks_attributes: [
                  {chemical_id: 4, inventory: 100.2},
                ]
            }
        }
    end
    assert_redirected_to edit_chemicals_inventory_path(chemical_inventories(:inventory1))
  end

  test "農薬棚卸編集(削除)" do
    assert_difference('ChemicalStock.count', -1) do
      assert_difference('ChemicalInventory.count', -1) do
        delete :destroy, params: {id: chemical_inventories(:inventory1).id}
      end
    end
    assert_redirected_to chemicals_inventories_path
  end
end
