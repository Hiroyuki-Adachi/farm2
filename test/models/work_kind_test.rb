# == Schema Information
#
# Table name: work_kinds(作業種別マスタ)
#
#  id(作業種別マスタ)               :integer          not null, primary key
#  aggregation_flag(集計対象フラグ) :boolean          default(FALSE), not null
#  broccoli_mark(ブロッコリ記号)    :string(1)
#  deleted_at                       :datetime
#  display_order(表示順)            :integer          not null
#  land_flag(土地利用フラグ)        :boolean          default(TRUE), not null
#  name(作業種別名称)               :string(20)       not null
#  other_flag(その他フラグ)         :boolean          default(FALSE), not null
#  phonetic(作業種別ふりがな)       :string(40)       default(""), not null
#  created_at                       :datetime
#  updated_at                       :datetime
#  cost_type_id(原価種別)           :integer
#
# Indexes
#
#  index_work_kinds_on_deleted_at  (deleted_at)
#

require 'test_helper'

class WorkKindTest < ActiveSupport::TestCase
  test "土地利用しない作業種別は集計対象にしない" do
    work_kind = WorkKind.new(
      name: "集計なし",
      phonetic: "しゅうけいなし",
      display_order: 999,
      cost_type: cost_types(:cost_types1),
      land_flag: false,
      aggregation_flag: true
    )
    work_kind.term = 2015
    work_kind.price = 1000
    work_kind.save!

    assert_not work_kind.aggregation_flag
  end

  test "集計対象は土地利用する作業種別のみにする" do
    work_kinds(:work_kind_taue).update_columns(land_flag: true, aggregation_flag: true)
    work_kinds(:work_kind_shirokaki).update_columns(land_flag: false, aggregation_flag: true)

    assert_includes WorkKind.aggregatable, work_kinds(:work_kind_taue)
    assert_not_includes WorkKind.aggregatable, work_kinds(:work_kind_shirokaki)
  end

  test "各年の単価設定" do
    work_kind = WorkKind.find(work_kinds(:work_kind_every_term).id) 
    assert_equal 2010, work_kind.term_price(2010)
    assert_equal 2015, work_kind.term_price(2015)
  end

  test "初年度のみ単価設定" do
    work_kind = WorkKind.find(work_kinds(:work_kind_first_term).id) 
    assert_equal work_kind_prices(:work_kind_prices_first_0).price, work_kind.term_price(2010)
    assert_equal systems(:s2015).default_price, work_kind.term_price(2015)
  end
end
