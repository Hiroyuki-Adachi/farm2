# == Schema Information
#
# Table name: works # 作業データ
#
#  id           :integer          not null, primary key # 作業データ
#  term         :integer          not null              # 年度(期)
#  worked_at    :date             not null              # 作業日
#  weather_id   :integer                                # 天気
#  work_type_id :integer                                # 作業分類
#  name         :string(40)       not null              # 作業名称
#  remarks      :text                                   # 備考
#  start_at     :datetime         not null              # 開始時刻
#  end_at       :datetime         not null              # 終了時刻
#  fixed_at     :date                                   # 確定日
#  work_kind_id :integer          default(0), not null  # 作業種別
#  created_at   :datetime
#  updated_at   :datetime
#  created_by   :integer                                # 作成者
#  printed_at   :datetime                               # 印刷日時
#  printed_by   :integer                                # 印刷者
#

require 'test_helper'

class WorkKindTest < ActiveSupport::TestCase
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
end
