require 'test_helper'

# == Schema Information
#
# Table name: chemicals(薬剤マスタ)
#
#  id(薬剤マスタ)             :integer          not null, primary key
#  aqueous_flag(水溶フラグ)   :boolean          default(FALSE), not null
#  base_quantity(消費数)      :decimal(6, )     default(0), not null
#  carton_quantity(購買数)    :decimal(6, )     default(0), not null
#  carton_unit(購買単位)      :string(2)        default(""), not null
#  deleted_at                 :datetime
#  display_order(表示順)      :integer          default(0), not null
#  name(薬剤名称)             :string(20)       not null
#  phonetic(薬剤ふりがな)     :string(40)       default(""), not null
#  stock_quantity(在庫数)     :decimal(6, )     default(0), not null
#  stock_unit(在庫単位)       :string(2)        default(""), not null
#  unit(単位)                 :string(2)        default("袋"), not null
#  url(URL)                   :string(255)      default(""), not null
#  created_at                 :datetime
#  updated_at                 :datetime
#  base_unit_id(基本単位)     :integer          default(0), not null
#  chemical_type_id(薬剤種別) :integer          not null
#  organization_id(組織)      :bigint           not null
#
# Indexes
#
#  index_chemicals_on_deleted_at       (deleted_at)
#  index_chemicals_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
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
