require 'test_helper'

class ChemicalTest < ActiveSupport::TestCase
  test "希釈scale・倍率(使用量単位がcc/gの場合はそのまま)" do
    chemical = Chemical.new(unit: "cc")

    assert_equal 1000, chemical.dilution_scale
    assert_equal 1, chemical.dilution_multiplier
    assert_equal 100, chemical.dilution_quantity(100)
  end

  test "希釈scale・倍率(使用量単位が本/袋/缶など個数単位の場合はbase_quantityで実量に変換)" do
    chemical = Chemical.new(unit: "本", base_quantity: 500)

    assert_equal 1000, chemical.dilution_scale
    assert_equal 500, chemical.dilution_multiplier
    assert_equal 1000, chemical.dilution_quantity(2)
    assert chemical.dilution_available?
  end

  test "dilution_available?(個数単位でbase_quantity未設定/0の場合はfalse)" do
    assert_not Chemical.new(unit: "本", base_quantity: 0).dilution_available?
    assert_not Chemical.new(unit: "袋").dilution_available?
  end
end
