# == Schema Information
#
# Table name: chemical_stocks
#
#  id                              :bigint           not null, primary key
#  adjust(調整量)                  :decimal(5, 1)    default(0.0), not null
#  inventory(棚卸量)               :decimal(7, 1)
#  name(在庫名称)                  :string(40)       default(""), not null
#  shipping(出庫量)                :decimal(5, 1)
#  stock(在庫量)                   :decimal(7, 1)    default(0.0), not null
#  stock_on(在庫日)                :date             not null
#  stored(入庫量)                  :decimal(5, 1)
#  using(使用量)                   :decimal(5, 1)
#  created_at                      :datetime         not null
#  updated_at                      :datetime         not null
#  chemical_id(薬剤)               :integer          not null
#  chemical_inventory_id(薬剤棚卸) :integer
#  work_chemical_id(薬剤使用)      :integer
#
require 'test_helper'

class ChemicalStockTest < ActiveSupport::TestCase
  test "在庫計算" do
    chemical_id = 4
    assert_difference('ChemicalStock.count', 3) do
      ChemicalStock.refresh(1, chemical_id)
    end
    work_chemical = work_chemicals(:work_chemical_stock)
    work_stock = ChemicalStock.find_by(work_chemical_id: work_chemical.id)
    assert_equal work_chemical.quantity, work_stock.using
    assert_equal work_chemical.work.worked_at, work_stock.stock_on

    stock1 = ChemicalStock.find(chemical_stocks(:stock_model1).id)
    assert_equal stock1.inventory, stock1.stock
    assert_equal stock1.inventory, stock1.adjust

    stock2 = ChemicalStock.find(chemical_stocks(:stock_model2).id)
    assert_equal stock1.stock + stock2.stored, stock2.stock
    assert_equal stock2.stored, stock2.adjust

    assert_equal stock2.stock - work_stock.using, work_stock.stock
    assert_equal -work_stock.using, work_stock.adjust

    stock4 = ChemicalStock.find(chemical_stocks(:stock_model4).id)
    assert_equal work_stock.stock + stock4.stored, stock4.stock
    assert_equal stock4.stored, stock4.adjust

    stock5 = ChemicalStock.find(chemical_stocks(:stock_model5).id)
    assert_equal stock4.stock - stock5.shipping, stock5.stock
    assert_equal -stock5.shipping, stock5.adjust

    stock6 = ChemicalStock.find(chemical_stocks(:stock_model6).id)
    assert_equal stock6.inventory, stock6.stock
    assert_equal stock6.inventory - stock5.stock, stock6.adjust
  end

  test "納品" do
    stock_quantity = 4
    stock_for_test = chemical_stocks(:stock_for_test)
    chemical = Chemical.find(stock_for_test.chemical_id)
    stock = ChemicalStock.find(stock_for_test.id)
    stock.stored_stock = stock_quantity
    stock.save!

    stock = ChemicalStock.find(stock_for_test.id)
    assert_equal stock_quantity * chemical.carton_quantity / chemical.stock_quantity, stock.stored
  end
end
