# == Schema Information
#
# Table name: works
#
#  id           :integer          not null, primary key
#  term         :integer          not null
#  worked_at    :date             not null
#  weather_id   :integer
#  work_type_id :integer
#  name         :string(40)       not null
#  remarks      :text
#  start_at     :datetime         not null
#  end_at       :datetime         not null
#  fixed_at     :date
#  work_kind_id :integer          default("0"), not null
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :integer
#  printed_at   :datetime
#  printed_by   :integer
#

require 'test_helper'

class WorkTest < ActiveSupport::TestCase
  setup do
    @work = works(:work_for_price)
    @sum_hours = work_results(:work_result_for_price1).hours + work_results(:work_result_for_price2).hours
    @sum_areas = lands(:lands0).area + lands(:lands1).area
  end

  test "作業者数" do
    assert_equal 2, @work.workers_count
  end

  test "作業時間" do
    assert_equal @sum_hours, @work.sum_hours
  end

  test "作業面積" do
    assert_equal @sum_areas, @work.sum_areas
  end

  test "作業単価" do
    assert_equal @work.term, @work.price
  end

  test "作業金額合計" do
    assert_equal @work.term * @sum_hours, @work.sum_workers_amount
  end

  test "工数統計_総合計" do
    total_hours = Work.joins(:work_results).where(term: 2015).sum("work_results.hours")
    assert_equal total_hours, Work.total_all[2015]
  end

  test "工数統計_ジャンル別" do
    total_hours = Work.joins(:work_results)
        .joins("INNER JOIN work_types ON works.work_type_id = work_types.id")
        .where(term: 2015, "work_types.genre" => 1).sum("work_results.hours")
    assert_equal total_hours, Work.total_genre[[1, 2015]]
  end

  test "工数統計_年齢別" do
    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker1).id).sum("work_results.hours")
    assert_equal total_hours, Work.total_age[[2015, 0]]

    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker2).id).sum("work_results.hours")
    assert_equal total_hours, Work.total_age[[2015, 2]]

    total_hours = Work.joins(:work_results)
        .where(term: 2015, "work_results.worker_id" => workers(:worker3).id).sum("work_results.hours")
    assert_equal total_hours, Work.total_age[[2015, 5]]
  end

  test "作業種別キャッシュ" do
    w = works(:work_for_work_type_cache)
    w.regist_work_work_types
    wts = w.work_types.order(id: :asc)
    assert_equal wts.count, 2
    assert wts.ids.include?(land_costs(:land_cost_genka1).work_type_id)
    assert wts.ids.include?(land_costs(:land_cost_genka21).work_type_id)
  end
end
