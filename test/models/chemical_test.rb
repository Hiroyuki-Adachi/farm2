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
  end
end
