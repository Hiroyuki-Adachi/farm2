require 'test_helper'

class TotalCost::RebuilderTest < ActiveSupport::TestCase
  setup do
    @term = 2017
    @sys = systems(:s2017)
    @land = lands(:land_genka2)
    @organization = organizations(:org)
    @rebuilder = TotalCost::Rebuilder.new(@organization, @term, Date.new(2017, 12, 31))
  end

  test "原価計算_作業費_作業者" do
    assert_difference('TotalCostDetail.count', 2) do
      assert_difference('TotalCost.count') do
        @rebuilder.make_work_worker(works(:work_genka))
      end
    end
    total_cost = TotalCost.find_by(organization: @organization, term: @term, total_cost_type_id: TotalCostType::WORKWORKER.id)
    assert_equal 6000, total_cost.amount

    assert_no_difference('TotalCostDetail.count') do
      @rebuilder.make_details
    end
    assert_in_delta 4000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 5).cost, 1
    assert_in_delta 2000, TotalCostDetail.find_by(total_cost_id: total_cost.id, work_type_id: 6).cost, 1
  end

  test "原価計算_作業費_作業者(非組合員)" do
    assert_difference('TotalCostDetail.count') do
      assert_difference('TotalCost.count') do
        @rebuilder.make_work_worker(works(:work_genka_worker))
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
    @rebuilder.make_details_for_indirect(total_cost, occurred_on)

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
