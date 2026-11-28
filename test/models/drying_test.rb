# == Schema Information
#
# Table name: dryings(乾燥)
#
#  id                       :bigint           not null, primary key
#  carried_on(搬入日)       :date             not null
#  copy_flag(複写フラグ)    :integer          default(0), not null
#  fixed_amount(確定額)     :decimal(7, )
#  shipped_on(出荷日)       :date
#  term(年度(期))           :integer          not null
#  water_content(水分)      :decimal(3, 1)
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  drying_type_id(乾燥種別) :integer          default("unset"), not null
#  home_id(担当世帯)        :integer          default(0), not null
#  work_type_id(作業分類)   :integer
#
# Indexes
#
#  dryings_secondary  (carried_on,home_id,copy_flag) UNIQUE
#

require 'test_helper'

class DryingTest < ActiveSupport::TestCase
  setup do
    @drying1 = dryings(:drying1)
    @system2015 = systems(:s2015)
  end

  test "乾燥調整価格" do
    drying2 = dryings(:drying2)
    adjustment1 = adjustments(:adjustment1)
    moth1 = drying_moths(:drying1_moth1)
    moth2 = drying_moths(:drying1_moth2)
    rice_weight1 = moth1.rice_weight + moth2.rice_weight

    assert_equal adjustment1.rice_bag * @system2015.dry_adjust_price, drying2.amount(@system2015, drying2.home_id)
    assert_equal adjustment1.waste_weight / Drying::KG_PER_BAG_WASTE * @system2015.waste_price, drying2.waste_amount(@system2015, drying2.home_id)
    assert_equal (rice_weight1 / Drying::KG_PER_BAG_RICE * @system2015.dry_price).floor(-1), @drying1.amount(@system2015, @drying1.home_id)
  end

  test "乾燥調整集計" do
    home = Home.find(@drying1.home_id)
    totals = Drying.calc_total(Drying.by_home(@drying1.term, home), home, @system2015)

    assert_equal @drying1.drying_moths.sum(:rice_weight), totals[0][:country]
  end

  # #1351 搬入日は世帯の組織と年度(term)の System の期首〜期末に入っていること
  test "搬入日が期内なら作成できる" do
    assert Drying.new(term: 2015, carried_on: Date.new(2015, 12, 31), home: homes(:home5)).valid?
  end

  test "搬入日が期外なら作成できない" do
    drying = Drying.new(term: 2015, carried_on: Date.new(2016, 1, 1), home: homes(:home5))

    assert_not drying.valid?
    assert_includes drying.errors[:carried_on], "は2015年度の期間内(2015/01/01〜2015/12/31)の日付を入力してください"
  end

  test "搬入日は世帯の組織の年度で検証する" do
    # 組織2には2014年度がない(組織1にはある)
    drying = Drying.new(term: 2014, carried_on: Date.new(2014, 9, 1), home: homes(:home_other_org))

    assert_not drying.valid?
    assert_includes drying.errors[:carried_on], "は2014年度の期間内(年度が未登録)の日付を入力してください"
  end

  test "期外の既存の乾燥でも搬入日・年度・世帯を変えない更新はできる" do
    drying = Drying.new(term: 2015, carried_on: Date.new(2016, 1, 2), home: homes(:home5))
    drying.save!(validate: false)

    assert drying.update(water_content: 15.0)
  end
end
