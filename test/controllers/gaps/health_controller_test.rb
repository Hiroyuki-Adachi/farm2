require "test_helper"

class Gaps::HealthControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "GAP体調確認表(一覧)" do
    get gaps_health_index_path
    assert_response :success
  end

  test "GAP体調確認表に他組織の作業者を表示しない" do
    other_work_type_id = 999_999
    health = Health.create!(code: "T", name: "テスト", well_flag: true)
    works(:work_other_org).update!(work_type_id: other_work_type_id)
    work_results(:work_result_other_org).update!(health: health)

    get gaps_health_index_path, params: { work_type_id: other_work_type_id }

    assert_response :success
    assert_select "th", text: workers(:worker_other_org).family_name, count: 0
    assert_select "th", text: workers(:worker_other_org).first_name, count: 0
  end
end
