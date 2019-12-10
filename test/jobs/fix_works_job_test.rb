require 'test_helper'

class FixWorksJobTest < ActiveJob::TestCase
  test "確定JOB" do
    no_fix_works = [works(:work_no_fix1).id, works(:work_no_fix2).id]
    assert_no_enqueued_jobs
    FixWorksJob.perform_later(2015, "2015-03-31", users(:users1).worker_id, no_fix_works)
    assert_enqueued_jobs 1
  end
end
