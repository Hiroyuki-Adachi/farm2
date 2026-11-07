require "test_helper"

class ChemicalStock::RefresherTest < ActiveSupport::TestCase
  test "在庫計算" do
    chemical_id = 4
    assert_difference('ChemicalStock.count', 3) do
      ChemicalStock::Refresher.new(1, chemical_id).call
    end
    work_chemical = work_chemicals(:work_chemical_stock)
    work_stock = ChemicalStock.find_by(work_chemical_id: work_chemical.id)
    assert_equal work_chemical.quantity_for_stock, work_stock.using
    assert_equal work_chemical.work.worked_at, work_stock.stock_on

    stock1 = ChemicalStock.find(chemical_stocks(:stock_model1).id)
    assert_equal stock1.inventory, stock1.stock
    assert_equal stock1.inventory, stock1.adjust

    stock2 = ChemicalStock.find(chemical_stocks(:stock_model2).id)
    assert_equal stock1.stock + stock2.stored, stock2.stock
    assert_equal stock2.stored, stock2.adjust

    assert_equal stock2.stock - work_stock.using, work_stock.stock
    assert_equal(-work_stock.using, work_stock.adjust)

    stock4 = ChemicalStock.find(chemical_stocks(:stock_model4).id)
    assert_equal work_stock.stock + stock4.stored, stock4.stock
    assert_equal stock4.stored, stock4.adjust

    stock5 = ChemicalStock.find(chemical_stocks(:stock_model5).id)
    assert_equal stock4.stock - stock5.shipping, stock5.stock
    assert_equal(-stock5.shipping, stock5.adjust)

    stock6 = ChemicalStock.find(chemical_stocks(:stock_model6).id)
    assert_equal stock6.inventory, stock6.stock
    assert_equal stock6.inventory - stock5.stock, stock6.adjust
  end

  test "在庫がない薬剤でも作業実績から在庫を作成する" do
    chemical_id = 4
    work_chemical = work_chemicals(:work_chemical_stock)
    ChemicalStock.for_organization(1).where(chemical_id: chemical_id).destroy_all

    before_count = ChemicalStock.for_organization(1).where(chemical_id: chemical_id).count
    ChemicalStock::Refresher.new(1, chemical_id).call
    assert_operator ChemicalStock.for_organization(1).where(chemical_id: chemical_id).count, :>, before_count

    stock = ChemicalStock.for_organization(1).find_by(work_chemical_id: work_chemical.id)
    assert_not_nil stock
    assert_equal work_chemical.quantity_for_stock, stock.using
    assert_equal work_chemical.work.worked_at, stock.stock_on
  end

  test "作業実績から作る在庫は他組織の既存行を更新しない" do
    work_chemical = work_chemicals(:work_chemical_stock)
    other_stock = chemical_stocks(:stock_for_test)
    other_stock.update_columns(
      organization_id: 2,
      work_chemical_id: work_chemical.id,
      chemical_id: work_chemical.chemical_id,
      using: 999
    )

    ChemicalStock::Refresher.new(1, work_chemical.chemical_id).call

    other_stock.reload
    assert_equal 2, other_stock.organization_id
    assert_equal 999, other_stock.using
  end
end
