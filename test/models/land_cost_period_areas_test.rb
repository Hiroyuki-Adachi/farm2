require "test_helper"

class LandCostPeriodAreasTest < ActiveSupport::TestCase
  setup do
    LandCost.delete_all
    @start_date = Date.new(2016, 1, 1)
    @end_date = Date.new(2016, 12, 31)
    @first = work_types(:work_types1)
    @second = work_types(:work_types2)
    @excluded = work_types(:work_type_mugi)
    @ids = [@first.id, @second.id]
    @land = lands(:lands0)
    @land.update!(area: 10, target_flag: true, start_on: @start_date, end_on: @end_date)
  end

  test "閏年の分類変更を日次集計と同じ面積日数で積算する" do
    add_history(@land, @first, Date.new(2015, 10, 1))
    add_history(@land, @second, Date.new(2016, 3, 1))
    result = period_areas
    assert_equal 600, result[@first.id]
    assert_equal 3060, result[@second.id]
    assert_matches_daily_sum(result)
  end

  test "対象外分類への変更期間は対象分類に加算しない" do
    add_history(@land, @first, Date.new(2015, 1, 1))
    add_history(@land, @excluded, Date.new(2016, 2, 1))
    add_history(@land, @second, Date.new(2016, 3, 1))
    # 年度末以後の変更は当期の集計に影響しない。
    add_history(@land, @excluded, Date.new(2017, 1, 1))
    result = period_areas
    assert_equal 310, result[@first.id]
    assert_equal 3060, result[@second.id]
    assert_matches_daily_sum(result)
  end

  test "圃場の開始終了日と履歴の初日を含めて期間を切り詰める" do
    @land.update!(start_on: Date.new(2016, 2, 29), end_on: Date.new(2016, 3, 2))
    add_history(@land, @first, Date.new(2016, 2, 28))
    add_history(@land, @second, Date.new(2016, 3, 1))
    result = period_areas
    assert_equal 10, result[@first.id]
    assert_equal 20, result[@second.id]
    assert_matches_daily_sum(result)
  end

  test "対象外削除済み他組織および有効期間外の圃場を除く" do
    add_history(@land, @first, @start_date)
    [
      { target_flag: false },
      { deleted_at: Time.current },
      { organization_id: organizations(:org2).id, owner_id: nil, manager_id: nil },
      { start_on: Date.new(2017, 1, 1), end_on: Date.new(2017, 12, 31) }
    ].each_with_index do |attributes, index|
      land = @land.dup
      land.assign_attributes(attributes.merge(uuid: SecureRandom.uuid, place: "除外#{index}"))
      land.save!
      add_history(land, @first, @start_date)
    end
    result = period_areas
    assert_equal 3660, result[@first.id]
    assert_matches_daily_sum(result)
  end

  test "履歴が年度途中に始まる場合はそれ以前の面積を計上しない" do
    add_history(@land, @second, Date.new(2016, 12, 31))
    result = period_areas
    assert_equal 10, result[@second.id]
    assert_matches_daily_sum(result)
  end

  test "候補がない場合はSQLを実行しない" do
    organization = organizations(:org)
    assert_no_queries do
      assert_empty LandCost.sum_period_areas_by_work_type(@start_date, @end_date, [], organization)
    end
  end

  private

  def add_history(land, type, date)
    LandCost.create!(land: land, work_type: type, activated_on: date)
  end

  def period_areas
    LandCost.sum_period_areas_by_work_type(@start_date, @end_date, @ids, organizations(:org))
  end

  def assert_matches_daily_sum(actual)
    expected = Hash.new(0)
    (@start_date..@end_date).each do |date|
      LandCost.sum_areas_by_work_type(date, @ids, organizations(:org)).each { |id, area| expected[id] += area }
    end
    @ids.each { |id| assert_equal expected[id], actual.fetch(id, 0) }
  end
end
