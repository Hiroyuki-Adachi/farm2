# == Schema Information
#
# Table name: systems(システムマスタ)
#
#  id(システムマスタ)                   :integer          not null, primary key
#  adjust_price(基準額(調整のみ))       :decimal(4, )     default(0), not null
#  default_fee(初期値(管理料))          :decimal(6, )     default(15000), not null
#  default_price(初期値(工賃))          :decimal(5, )     default(1000), not null
#  dry_adjust_price(基準額(乾燥調整))   :decimal(4, )     default(0), not null
#  dry_price(基準額(乾燥のみ))          :decimal(4, )     default(0), not null
#  end_date(期末日)                     :date             not null
#  half_sum_flag(半端米集計フラグ)      :boolean          default(FALSE), not null
#  light_oil_price(軽油価格)            :decimal(4, )     default(0), not null
#  relative_price(縁故米加算額)         :decimal(5, )     default(0), not null
#  roll_price                           :decimal(4, 1)    default(0.0), not null
#  seedling_price(育苗費)               :decimal(4, )     default(0), not null
#  start_date(期首日)                   :date             not null
#  term(年度(期))                       :integer          not null
#  waste_adjust_price(くず米金額(調整)) :decimal(4, )     default(0), not null
#  waste_drying_price(くず米金額(乾燥)) :decimal(4, )     default(0), not null
#  waste_price(くず米金額)              :decimal(4, )     default(0), not null
#  created_at                           :datetime
#  updated_at                           :datetime
#  organization_id(組織)                :integer          default(0), not null
#  seedling_chemical_id(育苗土)         :integer          default(0)
#
# Indexes
#
#  index_systems_on_term_and_organization_id  (term,organization_id) UNIQUE
#
require 'test_helper'

class SystemTest < ActiveSupport::TestCase
  test "前期がある場合は期首日が前期期末日の翌日であること" do
    system = systems(:s2015)
    system.start_date = Date.new(2015, 2, 1)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は前期の期末日の翌日にしてください。"
  end

  test "期末日は期首日以降であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2014, 12, 31)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は期首日以降にしてください。"
  end

  test "期首日は月初であること" do
    system = systems(:s2015)
    system.start_date = Date.new(2015, 1, 2)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は月初にしてください。"
  end

  test "期末日は月末であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2015, 12, 30)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は月末にしてください。"
  end

  test "次期がある場合は期末日が次期期首日の前日であること" do
    system = systems(:s2015)
    system.end_date = Date.new(2015, 11, 30)

    assert_not_predicate system, :valid?
    assert_includes system.errors[:end_date], "は次期の期首日の前日にしてください。"
  end

  test "同一組織内で期間が他期と重複しないこと" do
    system = System.new(
      organization_id: organizations(:org).id,
      term: 2018,
      start_date: Date.new(2017, 12, 1),
      end_date: Date.new(2018, 12, 31)
    )

    assert_not_predicate system, :valid?
    assert_includes system.errors[:base], "期首日と期末日が他の期と重複しています。"
  end

  test "term の前後関係と日付の前後関係が逆転しないこと" do
    system = System.new(
      organization_id: organizations(:org).id,
      term: 2018,
      start_date: Date.new(2013, 1, 1),
      end_date: Date.new(2013, 12, 31)
    )

    assert_not_predicate system, :valid?
    assert_includes system.errors[:start_date], "は前期以前の期間より後にしてください。"
  end

  test "前期がない初年度は前期連続チェックをしない" do
    organization = Organization.create!(name: "初年度テスト", term: 2025)
    system = System.new(
      organization_id: organization.id,
      term: 2025,
      start_date: Date.new(2025, 4, 1),
      end_date: Date.new(2026, 3, 31)
    )

    assert_predicate system, :valid?
  end
end
