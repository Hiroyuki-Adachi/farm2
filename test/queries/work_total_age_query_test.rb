require "test_helper"

class WorkTotalAgeQueryTest < ActiveSupport::TestCase
  test "年度別年齢別作業集計クエリ" do
    total_ages = WorkTotalAgeQuery.new.call

    total_hours = Work.joins(:work_results)
      .where(term: 2015, "work_results.worker_id" => workers(:worker1).id).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 0]]

    total_hours = Work.joins(:work_results)
      .where(term: 2015, "work_results.worker_id" => workers(:worker2).id).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 2]]

    total_hours = Work.joins(:work_results)
      .joins('INNER JOIN workers ON workers.id = work_results.worker_id AND workers.gender_id = 2')
      .where(term: 2015).sum("work_results.hours")
    assert_equal total_hours, total_ages[[2015, 5]]
  end

  test "年度別年齢別作業集計クエリは組織で絞り込める" do
    create_age_summary_work(
      organization: organizations(:org),
      worker: workers(:worker1),
      hours: 2
    )
    create_age_summary_work(
      organization: organizations(:org2),
      worker: workers(:worker_other_org),
      hours: 7
    )

    total_ages = WorkTotalAgeQuery.new(organization: organizations(:org)).call

    assert_equal 2, total_ages[[2026, 1]]
  end

  private

  def create_age_summary_work(organization:, worker:, hours:)
    work = Work.create!(
      organization: organization,
      term: 2026,
      worked_at: Date.new(2026, 1, 15),
      weather_id: :sunny,
      work_type: work_types(:work_type_koshi),
      work_kind: work_kinds(:work_kind_every_term),
      name: "年齢別集計テスト",
      start_at: "08:00",
      end_at: "17:00"
    )
    WorkResult.create!(work: work, worker: worker, hours: hours, display_order: 1)
    work
  end
end
