require "test_helper"

class InitWorkTypeCacheJobTest < ActiveJob::TestCase
  test "Work.no_fixed.landable が呼ばれ、各レコードで regist_work_work_types が実行される" do
    term = 2024
    work1 = mock("work1")
    work2 = mock("work2")
    work1.expects(:regist_work_work_types)
    work2.expects(:regist_work_work_types)

    relation = mock("relation")
    Work.expects(:for_organization).with(organizations(:org)).returns(relation)
    relation.expects(:no_fixed).with(term).returns(relation)
    relation.expects(:landable).returns(relation)
    relation.expects(:find_each).multiple_yields([work1], [work2])

    create_systems_until(term, organizations(:org))

    travel_to Time.zone.local(2024, 3, 22) do
      perform_enqueued_jobs { InitWorkTypeCacheJob.perform_now }
    end
  end

  test "キュー名が default である" do
    assert_equal "default", InitWorkTypeCacheJob.queue_name
  end

  private

  def create_systems_until(term, organization)
    previous = System.where(organization_id: organization.id).order(:term).last

    ((previous.term + 1)..term).each do |target_term|
      System.create!(
        term: target_term,
        start_date: previous.end_date.next_day,
        end_date: previous.end_date.next_day.next_year.prev_day,
        organization_id: organization.id
      )
      previous = System.find_by!(term: target_term, organization_id: organization.id)
    end
  end
end
