require "test_helper"

class Chemicals::InventoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @chemical_inventory = chemical_inventories(:inventory1)
  end

  test "農薬棚卸一覧" do
    get chemicals_inventories_path
    assert_response :success
  end

  test "農薬棚卸一覧(管理者以外)" do
    login_as(users(:user_checker))
    get chemicals_inventories_path
    assert_response :error
  end

  test "農薬棚卸新規作成(表示)" do
    get new_chemicals_inventory_path
    assert_response :success
  end

  test "農薬棚卸新規作成(実行)" do
    chemical_inventory = {checked_on: '2015-01-05', name: "当初在庫"}
    assert_difference('ChemicalInventory.count') do
      post chemicals_inventories_path, params: {chemical_inventory: chemical_inventory}
    end

    created_chemical_inventory = ChemicalInventory.last
    assert_redirected_to edit_chemicals_inventory_path(created_chemical_inventory)

    assert_equal chemical_inventory[:checked_on], created_chemical_inventory.checked_on.to_s
    assert_equal chemical_inventory[:name], created_chemical_inventory.name
  end

  test "農薬棚卸編集(表示)" do
    get edit_chemicals_inventory_path(@chemical_inventory)
    assert_response :success
  end

  test "農薬棚卸編集(実行)" do
    chemical_inventory = {
      checked_on: '2015-12-25',
      name: "期末在庫",
      stocks_attributes: [
        {chemical_id: 4, inventory: 100.2}
      ]
    }

    assert_no_difference('ChemicalInventory.count') do
      patch chemicals_inventory_path(@chemical_inventory), params: {
        chemical_inventory: chemical_inventory
      }
    end
    assert_redirected_to edit_chemicals_inventory_path(@chemical_inventory)

    @chemical_inventory.reload
    assert_equal chemical_inventory[:checked_on], @chemical_inventory.checked_on.to_s
    assert_equal chemical_inventory[:name], @chemical_inventory.name
    assert_equal chemical_inventory[:stocks_attributes][0][:chemical_id], @chemical_inventory.stocks[0].chemical_id
    assert_equal chemical_inventory[:stocks_attributes][0][:inventory], @chemical_inventory.stocks[0].inventory
  end

  test "農薬棚卸編集(削除)" do
    assert_difference('ChemicalStock.count', -1) do
      assert_difference('ChemicalInventory.count', -1) do
        delete chemicals_inventory_path(@chemical_inventory)
      end
    end
    assert_redirected_to chemicals_inventories_path

    assert_nil ChemicalInventory.find_by(id: @chemical_inventory.id)
    assert_empty ChemicalStock.where(chemical_inventory_id: @chemical_inventory.id)
  end
end
