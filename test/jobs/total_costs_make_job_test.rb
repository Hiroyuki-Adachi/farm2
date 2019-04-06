require 'test_helper'

class TotalCostsMakeJobTest < ActiveJob::TestCase
  include ActiveJob::TestHelper

  test "原価計算JOB" do
    assert_no_enqueued_jobs
    TotalCostsMakeJob.perform_later(2017)
    assert_enqueued_jobs 1
  end
end
