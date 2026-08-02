require 'test_helper'

class WorkChemicalTest < ActiveSupport::TestCase
  test "希釈水量(使用量単位がcc/gの場合)" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 100, magnification: 200
    )

    assert_equal 20, work_chemical.dilution_amount
  end

  test "希釈水量(使用量単位が本など個数単位の場合はbase_quantityで実量換算してから計算)" do
    chemical = Chemical.new(unit: "本", base_quantity: 500)
    work_chemical = WorkChemical.new(chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 2, magnification: 200)

    assert_equal 200, work_chemical.dilution_amount
  end

  test "希釈無のときはnil" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(chemical: chemical, dilution_id: Dilution::NONE.id, quantity: 100)

    assert_nil work_chemical.dilution_amount
  end

  test "希釈選択済でもmagnification未入力のときは例外にならずnil" do
    chemical = Chemical.new(unit: "cc")
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 100, magnification: nil
    )

    assert_nil work_chemical.dilution_amount
  end

  test "個数単位でbase_quantityが未設定/0のときは実量換算できないためnil" do
    chemical = Chemical.new(unit: "本", base_quantity: 0)
    work_chemical = WorkChemical.new(
      chemical: chemical, dilution_id: Dilution::MAG.id, quantity: 2, magnification: 200
    )

    assert_nil work_chemical.dilution_amount
  end
end
