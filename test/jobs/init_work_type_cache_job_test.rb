require "test_helper"

class InitWorkTypeCacheJobTest < ActiveJob::TestCase
  test "Work.no_fixed(term).landable が呼ばれ、各レコードで regist_work_work_types が実行される" do
    term = 2024
    work1 = mock("work1")
    work2 = mock("work2")
    work1.expects(:regist_work_work_types)
    work2.expects(:regist_work_work_types)

    relation = mock("relation")
    Work.expects(:no_fixed).with(term).returns(relation)
    relation.expects(:landable).returns(relation)
    relation.expects(:find_each).multiple_yields([work1], [work2])

    perform_enqueued_jobs { InitWorkTypeCacheJob.perform_now(term) }
  end

  test "キュー名が default である" do
    assert_equal "default", InitWorkTypeCacheJob.queue_name
  end
end
