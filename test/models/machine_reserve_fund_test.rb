require "test_helper"

# == Schema Information
#
# Table name: machine_reserve_funds(基盤強化準備金原価)
#
#  id                             :bigint           not null, primary key
#  remaining_amount(残額(初期値)) :decimal(9, )     not null
#  started_on(開始年月)           :date             not null
#  total_amount(総額)             :decimal(9, )     not null
#  years(配分年数)                :integer          default(7), not null
#  created_at                     :datetime         not null
#  updated_at                     :datetime         not null
#  machine_id(機械)               :integer          not null
#  organization_id(組織)          :bigint           not null
#
# Indexes
#
#  index_machine_reserve_funds_on_machine_id       (machine_id) UNIQUE
#  index_machine_reserve_funds_on_organization_id  (organization_id)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#
class MachineReserveFundTest < ActiveSupport::TestCase
  setup do
    @organization = organizations(:org)
    @machine = machines(:machines1)
  end

  test "必須項目が揃っていれば登録できる" do
    reserve_fund = MachineReserveFund.new(
      organization: @organization, machine: @machine, started_on: Date.new(2025, 4, 1),
      years: 7, total_amount: 3_500_000, remaining_amount: 3_500_000
    )
    assert reserve_fund.valid?
  end

  test "started_on/total_amount/remaining_amountが無いと登録できない" do
    reserve_fund = MachineReserveFund.new(organization: @organization, machine: @machine)
    assert_not reserve_fund.valid?
    assert_includes reserve_fund.errors.attribute_names, :started_on
    assert_includes reserve_fund.errors.attribute_names, :total_amount
    assert_includes reserve_fund.errors.attribute_names, :remaining_amount
  end

  test "yearsは1以上の整数でなければならない" do
    reserve_fund = build_reserve_fund(years: 0, total_amount: 100)
    assert_not reserve_fund.valid?
    assert_includes reserve_fund.errors.attribute_names, :years
  end

  test "同じ機械に対して2件登録できない" do
    build_reserve_fund(total_amount: 100).save!
    duplicated = build_reserve_fund(started_on: Date.new(2026, 4, 1), total_amount: 200)
    assert_not duplicated.valid?
    assert_includes duplicated.errors.attribute_names, :machine_id
  end

  test "残額は総額より大きくできない" do
    reserve_fund = build_reserve_fund(total_amount: 1_000_000, remaining_amount: 1_200_000)
    assert_not reserve_fund.valid?
    assert_includes reserve_fund.errors.attribute_names, :remaining_amount
  end

  test "登録済み明細の合計額より残額を小さくできない" do
    reserve_fund = build_reserve_fund(total_amount: 1_000_000).tap(&:save!)
    create_detail(reserve_fund, amount: 400_000)

    reserve_fund.remaining_amount = 300_000
    assert_not reserve_fund.valid?
    assert_includes reserve_fund.errors.attribute_names, :remaining_amount

    reserve_fund.remaining_amount = 400_000
    assert reserve_fund.valid?
  end

  test "registered_amount/current_remaining_amountは明細の合計から算出される" do
    reserve_fund = build_reserve_fund(total_amount: 1_000_000, remaining_amount: 700_000).tap(&:save!)
    assert_equal 0, reserve_fund.registered_amount
    assert_equal 700_000, reserve_fund.current_remaining_amount
    assert_not reserve_fund.details?

    create_detail(reserve_fund, amount: 150_000)

    assert_equal 150_000, reserve_fund.registered_amount
    assert_equal 550_000, reserve_fund.current_remaining_amount
    assert reserve_fund.details?
  end

  test "明細をpreloadした状態でもregistered_amountは追加クエリなしで算出される" do
    reserve_fund = build_reserve_fund(total_amount: 1_000_000, remaining_amount: 700_000).tap(&:save!)
    create_detail(reserve_fund, amount: 150_000)

    reloaded = MachineReserveFund.includes(:machine_reserve_fund_details).find(reserve_fund.id)
    assert reloaded.machine_reserve_fund_details.loaded?

    assert_no_queries { assert_equal 150_000, reloaded.registered_amount }
  end

  test "明細が存在すると削除できない" do
    reserve_fund = build_reserve_fund(total_amount: 1_000_000).tap(&:save!)
    create_detail(reserve_fund, amount: 150_000)

    assert_raises(ActiveRecord::DeleteRestrictionError) { reserve_fund.destroy! }
    assert MachineReserveFund.exists?(reserve_fund.id)
  end

  test "usualスコープは開始年月を優先し、同じなら機種・機械の表示順で並ぶ" do
    other_machine = machines(:machines2)
    later = build_reserve_fund(total_amount: 100).tap(&:save!)
    earlier = build_reserve_fund(machine: other_machine, started_on: Date.new(2024, 4, 1),
                                 total_amount: 100).tap(&:save!)

    assert_equal [earlier, later], MachineReserveFund.for_organization(@organization).usual.to_a
  end

  private

  def build_reserve_fund(total_amount:, machine: @machine, started_on: Date.new(2025, 4, 1), years: 7,
                         remaining_amount: nil)
    MachineReserveFund.new(
      organization: @organization, machine: machine, started_on: started_on, years: years,
      total_amount: total_amount, remaining_amount: remaining_amount || total_amount
    )
  end

  def create_detail(reserve_fund, amount:)
    MachineReserveFundDetail.create!(
      organization: @organization, machine_reserve_fund: reserve_fund,
      term: 2025, months: 12, amount: amount, remaining_amount: reserve_fund.remaining_amount - amount
    )
  end
end
