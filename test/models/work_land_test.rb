# == Schema Information
#
# Table name: work_lands # 作業地データ
#
#  id            :integer          not null, primary key # 作業地データ
#  work_id       :integer                                # 作業
#  land_id       :integer                                # 土地
#  display_order :integer          default(0), not null  # 表示順
#  created_at    :datetime
#  updated_at    :datetime
#

require 'test_helper'

class WorkLandTest < ActiveSupport::TestCase
  test "作業原価" do
    work_land1 = work_lands(:work_land_test1)
    work_land_max = work_lands(:work_land_test_max)
    work = works(:works_work_land_test)

    interim_cost1 = (work.sum_workers_amount * work_land1.land.area / work.sum_areas).round
    interim_cost_max = (work.sum_workers_amount * work_land_max.land.area / work.sum_areas).round

    assert_equal interim_cost1, work_land1.interim_cost
    assert_equal interim_cost1, work_land1.cost
    assert_equal interim_cost_max, work_land_max.interim_cost

    sum_interim_cost = interim_cost1
    sum_interim_cost += (work.sum_workers_amount * work_lands(:work_land_test2).land.area / work.sum_areas).round
    sum_interim_cost += (work.sum_workers_amount * work_lands(:work_land_test3).land.area / work.sum_areas).round
    sum_interim_cost += (work.sum_workers_amount * work_lands(:work_land_test4).land.area / work.sum_areas).round
    sum_interim_cost += interim_cost_max

    assert_equal interim_cost_max + (work.sum_workers_amount - sum_interim_cost), work_land_max.cost
  end
end
