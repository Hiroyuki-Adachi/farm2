# == Schema Information
#
# Table name: total_costs # 集計原価
#
#  id                 :bigint(8)        not null, primary key
#  term               :integer          not null                 # 年度(期)
#  total_cost_type_id :integer          not null                 # 集計原価種別
#  occurred_on        :date             not null                 # 発生日
#  work_id            :integer                                   # 作業
#  expense_id         :integer                                   # 経費
#  depreciation_id    :integer                                   # 減価償却
#  work_chemical_id   :integer                                   # 薬剤使用
#  amount             :decimal(9, )     not null                 # 原価額
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  seedling_home_id   :integer                                   # 育苗担当
#  member_flag        :boolean          default(FALSE), not null # 組合員支払フラグ
#  land_id            :integer                                   # 土地
#  fiscal_flag        :boolean          default(FALSE), not null # 決算期フラグ
#  display_order      :integer          default(0), not null     # 並び順
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

  test "原価計算_作業費_機械使用" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_machine(@term, @work)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::WORKMACHINE.id)
    assert_equal 4100 * 3, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta 8200, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 4100, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_作業費_薬剤" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_chemical(@term, @work)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::WORKCHEMICAL.id)
    assert_equal 600 * 5, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta 600 * 4, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 600 * 1, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_作業費_燃料" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_fuel(@term, @work, @sys)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::WORKFUEL.id)
    assert_equal 4500, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta 3000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 1500, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_土地管理" do
    land_cost = 40_000
    assert_difference('TotalCostDetail.count', 4) do
      assert_difference('TotalCost.count', 3) do
        TotalCost.make_lands(@term, @sys)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::LAND.id, land_id: @land.id)
    assert_equal land_cost, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta land_cost * (365 - 31) / 365, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta land_cost * 31 / 365, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 8).cost, 1
  end

  test "原価計算_減価償却" do
    dep_cost = 300_000
    rate8 = (@land.area * (365 - 31) / 365).round(2)
    TotalCost.make_lands(@term, @sys)
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_depreciation(@term, @sys)
      end
    end
    total_cost = TotalCost.find_by(term: @term, total_cost_type_id: TotalCostType::DEPRECIATION.id)
    assert_equal dep_cost, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@term)
    end
    assert_in_delta dep_cost * rate8 / (20 + rate8), TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta dep_cost * 20 / (20 + rate8), TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end
end
