require "test_helper"

class Statistics::WorkDaysControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別作業一覧" do
    systems(:s2015).update!(term_name: "第15期")

    get statistics_work_days_path

    assert_response :success
    assert_select "th", text: "第15期"
  end

  test "世帯別作業一覧に他組織の世帯を表示しない" do
    get statistics_work_days_path

    assert_response :success
    assert_no_match homes(:home_other_org).name, @response.body
  end
end
