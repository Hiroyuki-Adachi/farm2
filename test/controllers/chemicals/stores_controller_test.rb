require "test_helper"

class Chemicals::StoresControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @inventory = chemical_inventories(:store1)
  end
    
  test "農薬納品一覧" do
    get chemicals_stores_path
    assert_response :success
  end

  test "農薬納品一覧(管理者以外)" do
    login_as(users(:user_checker))
    get chemicals_stores_path
    assert_response :error
  end

  test "農薬納品新規作成(表示)" do
    get new_chemicals_store_path
    assert_response :success
  end

  test "農薬納品新規作成(実行)" do
    chemical_inventory = {checked_on: '2015-01-10', name: "当初納品"}
    assert_difference('ChemicalInventory.count') do
      post chemicals_stores_path, params: {chemical_inventory: chemical_inventory}
    end
    created_chemical_inventory = ChemicalInventory.last
    assert_redirected_to edit_chemicals_store_path(created_chemical_inventory)

    assert_equal chemical_inventory[:checked_on], created_chemical_inventory.checked_on.to_s
    assert_equal chemical_inventory[:name], created_chemical_inventory.name
  end

  test "農薬納品編集(表示)" do
    get edit_chemicals_store_path(@inventory.id)
    assert_response :success
  end

  test "農薬納品編集(実行)" do
    chemical_id = 4
    stored_stock = 100.2
    chemical_inventory = {
      checked_on: '2015-12-01',
      name: "期末納品",
      stocks_attributes: [
        {chemical_id: chemical_id, stored_stock: stored_stock}
      ]
    }

    assert_no_difference('ChemicalInventory.count') do
      patch chemicals_store_path(@inventory.id), params: {
        chemical_inventory: chemical_inventory
      }
    end
    assert_redirected_to edit_chemicals_store_path(@inventory.id)

    @inventory.reload
    assert_equal chemical_inventory[:checked_on], @inventory.checked_on.to_s
    assert_equal chemical_inventory[:name], @inventory.name

    updated_stock = ChemicalStock.find_by(chemical_inventory_id: @inventory.id, chemical_id: chemical_id)
    assert_not_nil updated_stock
    assert_equal stored_stock, updated_stock.stored_stock
  end

  test "農薬納品編集(削除)" do
    assert_difference('ChemicalStock.count', -1) do
      assert_difference('ChemicalInventory.count', -1) do
        delete chemicals_store_path(@inventory.id)
      end
    end
    assert_redirected_to chemicals_stores_path

    assert_nil ChemicalInventory.find_by(id: @inventory.id)
    assert_empty ChemicalStock.where(chemical_inventory_id: @inventory.id)
  end
end
