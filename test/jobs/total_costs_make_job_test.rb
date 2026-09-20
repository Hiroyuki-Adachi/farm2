require 'test_helper'

class TotalCostsMakeJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test "原価計算JOB" do
    perform_enqueued_jobs do
      TotalCostsMakeJob.perform_later(organizations(:org).id, 2017, '2017-12-31')
    end

    assert_equal Date.new(2017, 12, 31), systems(:s2017).reload.total_cost_fixed_on
    assert_nil systems(:s2015).reload.total_cost_fixed_on
    assert_not_empty TotalCost.for_organization(organizations(:org)).where(term: 2017)
  end
  test "計算失敗時は以前の締め月を維持する" do
    systems(:s2017).update!(total_cost_fixed_on: Date.new(2017, 2, 28))
    TotalCost.stubs(:make_details).raises("calculation failed")

    assert_raises(RuntimeError) do
      TotalCostsMakeJob.perform_now(organizations(:org).id, 2017, '2017-12-31')
    end

    assert_equal Date.new(2017, 2, 28), systems(:s2017).reload.total_cost_fixed_on
  end

  test "集計結果が0件でも計算済みの締め月を保存する" do
    TotalCostsMakeJob.perform_now(organizations(:org).id, 2017, '2016-12-31')

    assert_empty TotalCost.for_organization(organizations(:org)).where(term: 2017)
    assert_equal Date.new(2016, 12, 31), systems(:s2017).reload.total_cost_fixed_on
  end
end
