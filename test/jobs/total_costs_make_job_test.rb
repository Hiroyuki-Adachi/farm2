require 'test_helper'

class TotalCostsMakeJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test "原価計算JOB" do
    perform_enqueued_jobs do
      TotalCostsMakeJob.perform_later(2017, '2017-12-31')
    end

    assert_not_empty TotalCost.where(term: 2017)
  end
end
