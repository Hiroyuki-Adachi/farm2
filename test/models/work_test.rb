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
    assert_equal 2015, @work.price
  end

  test "作業金額合計" do
    assert_equal 2015 * @sum_hours, @work.sum_workers_amount
  end
end
