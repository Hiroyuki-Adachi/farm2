# == Schema Information
#
# Table name: total_costs(集計原価)
#
#  id                                     :bigint           not null, primary key
#  amount(原価額)                         :decimal(9, )     not null
#  display_order(並び順)                  :integer          default(0), not null
#  fiscal_flag(決算期フラグ)              :boolean          default(FALSE), not null
#  member_flag(組合員支払フラグ)          :boolean          default(FALSE), not null
#  occurred_on(発生日)                    :date             not null
#  term(年度(期))                         :integer          not null
#  created_at                             :datetime         not null
#  updated_at                             :datetime         not null
#  cost_type_id(原価種別)                 :integer
#  depreciation_id(減価償却)              :integer
#  land_id(土地)                          :integer
#  machine_id(機械)                       :integer
#  seedling_home_id(育苗担当)             :integer
#  sorimachi_account_id(ソリマチ勘定科目) :integer
#  sorimachi_journal_id(ソリマチ仕訳)     :integer
#  total_cost_type_id(集計原価種別)       :integer          not null
#  whole_crop_land_id(WCS土地)            :integer
#  work_chemical_id(薬剤使用)             :integer
#  work_id(作業)                          :integer
#
# Indexes
#
#  index_total_costs_on_term_and_occurred_on  (term,occurred_on)
#

require 'test_helper'

class TotalCostTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_genka)
    @term = 2017
    @sys = systems(:s2017)
    @land = lands(:land_genka2)
  end

  test "原価計算_作業費_作業者" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_worker(@term, @work)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::WORKWORKER.id)
    assert_equal 6000, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta 4000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 2000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_土地" do
    assert_difference('TotalCostDetail.count', 6) do
      assert_difference('TotalCost.count', 3) do
        TotalCost.make_lands(@term, @sys)
      end
    end

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end

    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::LAND.id)
    assert_equal 17500, total_cost.amount
    total_cost_detail = TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5)
    assert_in_delta total_cost.amount * (365 - 31) / 365, total_cost_detail.cost, 1
    total_cost_detail = TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 8)
    assert_in_delta total_cost.amount * 31 / 365, total_cost_detail.cost, 1

    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::PEASANT.id)
    assert_equal 26250, total_cost.amount
    total_cost_detail = TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5)
    assert_in_delta total_cost.amount * (365 - 31) / 365, total_cost_detail.cost, 1
    total_cost_detail = TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 8)
    assert_in_delta total_cost.amount * 31 / 365, total_cost_detail.cost, 1
  end

  test "原価計算_機械稼働時間" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count', 1) do
        TotalCost.make_machines(@term, Date.new(@term, 6, 30))
      end
    end
    machine_minute = machine_results(:machine_result_genka1).hours * 60
    machine_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::MACHINE.id)
    assert_equal machine_minute, machine_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end

    assert_in_delta machine_minute * 2 / 3, TotalCostDetail.find_by(total_cost_id: machine_cost.id, work_type_id: 5).cost, 1
    assert_in_delta machine_minute * 1 / 3, TotalCostDetail.find_by(total_cost_id: machine_cost.id, work_type_id: 6).cost, 1
  end
end
