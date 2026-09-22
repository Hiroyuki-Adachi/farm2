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
#  land_id(土地)                          :integer
#  machine_id(機械)                       :integer
#  organization_id(組織)                  :bigint           default(3), not null
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
#  index_total_costs_on_organization_id                           (organization_id)
#  index_total_costs_on_organization_id_and_term_and_occurred_on  (organization_id,term,occurred_on)
#  index_total_costs_on_term_and_occurred_on                      (term,occurred_on)
#
# Foreign Keys
#
#  fk_rails_...  (organization_id => organizations.id)
#

require 'test_helper'

class TotalCostTest < ActiveSupport::TestCase
  setup do
    @term = 2017
    @sys = systems(:s2017)
    @land = lands(:land_genka2)
    @organization = organizations(:org)
  end

  test "原価計算_作業費_作業者" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_worker(@term, works(:work_genka))
      end
    end
    total_cost = TotalCost.find_by(organization: @organization, term: @term, total_cost_type_id: TotalCostType::WORKWORKER.id)
    assert_equal 6000, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      TotalCost.make_details(@organization, @term)
    end
    assert_in_delta 4000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 2000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_作業費_作業者(非組合員)" do
    assert_difference('TotalCostDetail.count') do
      assert_difference('TotalCost.count') do
        TotalCost.make_work_worker(@term, works(:work_genka_worker))
      end
    end

    total_cost = TotalCost.find_by(organization: @organization, term: @term, total_cost_type_id: TotalCostType::WORKWORKER.id)
    assert_equal 3000, total_cost.amount
  end

  test "原価計算_間接費_その年に作付していない作業分類は集計されない" do
    occurred_on = Date.new(2017, 3, 1)
    planted = work_type_for_term("植付有", @term)
    not_planted = work_type_for_term("植付無", 2016)
    land_with_cost(planted, "植付有地")
    land_with_cost(not_planted, "植付無地")

    total_cost = TotalCost.create!(
      term: @term, total_cost_type_id: TotalCostType::AREA.id, occurred_on: occurred_on,
      organization: @organization, amount: 1000, display_order: 0
    )
    TotalCost.make_details_for_indirect(total_cost, @term, occurred_on)

    assert total_cost.total_cost_details.exists?(work_type_id: planted.id)
    assert_not total_cost.total_cost_details.exists?(work_type_id: not_planted.id)
  end

  private

  def work_type_for_term(name, term)
    work_type = WorkType.create!(name: name, genre: work_genres(:genre_change), land_flag: true, work_flag: true)
    work_type.term = term
    work_type.term_flag = true
    work_type.save!
    work_type
  end

  def land_with_cost(work_type, place)
    land = Land.create!(
      place: place, owner_id: 5, manager_id: 5, area: 10.0, reg_area: 10.0, organization: @organization
    )
    LandCost.create!(activated_on: "2015-01-01", land: land, work_type: work_type)
    land
  end
end
