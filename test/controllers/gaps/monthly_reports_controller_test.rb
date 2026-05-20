require "test_helper"

class Gaps::MonthlyReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP作業月毎記録表(一覧)" do
    get gaps_monthly_reports_path
    assert_response :success
  end

  test "GAP作業月毎記録表に他組織の作業を表示しない" do
    other_work = create_other_organization_monthly_report_work

    get gaps_monthly_reports_path, params: { work_type_id: other_work.work_type_id, worked_at: other_work.worked_at }

    assert_response :success
    assert_no_match other_work.name, @response.body
  end

  test "GAP作業月毎記録表の年月候補に他組織の作業月を表示しない" do
    other_work = create_other_organization_monthly_report_work

    get months_gaps_monthly_report_path(other_work.work_type_id)

    assert_response :success
    assert_no_match "2015年 04月", @response.body
  end

  private

  def create_other_organization_monthly_report_work
    work_type = WorkType.create!(
      genre: work_genres(:genre_rice),
      name: "他組織月報",
      display_order: 999,
      land_flag: true
    )
    Work.create!(
      organization: organizations(:org2),
      term: 2015,
      worked_at: Date.new(2015, 4, 1),
      weather_id: :sunny,
      work_type: work_type,
      work_kind: work_kinds(:work_kind_taue),
      name: "他組織月報作業",
      start_at: "08:00",
      end_at: "12:00",
      created_by: workers(:worker_other_org).id
    )
  end
end
