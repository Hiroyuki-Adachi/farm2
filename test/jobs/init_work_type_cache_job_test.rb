require "test_helper"

class InitWorkTypeCacheJobTest < ActiveJob::TestCase
  test "Work.no_fixed.landable が呼ばれ、各レコードで regist_work_work_types が実行される" do
    term = 2024
    work1 = mock("work1")
    work2 = mock("work2")
    work1.expects(:regist_work_work_types)
    work2.expects(:regist_work_work_types)

    relation = mock("relation")
    Work.expects(:no_fixed).with(term).returns(relation)
    relation.expects(:landable).returns(relation)
    relation.expects(:find_each).multiple_yields([work1], [work2])

    System.create(
      term: term,
      target_from: '2024-01-01',
      target_to: '2024-12-31',
      start_date: '2024-01-01',
      end_date: '2024-12-31',
      organization_id: organizations(:org).id
    )

    travel_to Time.zone.local(2024, 3, 22) do
      perform_enqueued_jobs { InitWorkTypeCacheJob.perform_now }
    end
  end

  test "キュー名が default である" do
    assert_equal "default", InitWorkTypeCacheJob.queue_name
  end
end
