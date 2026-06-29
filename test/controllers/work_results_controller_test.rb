require 'test_helper'

class WorkResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別日当一覧" do
    create_other_organization_result

    get work_results_path
    assert_response :success
    assert_not_includes response.body, homes(:home_other_org).name

    get work_results_path, params: { fixed_at: "2015-02-28" }
    assert_response :success
  end

  test "確定日当一覧に他組織の作業結果を表示しない" do
    works(:work_other_org).update!(fixed_at: Date.new(2015, 2, 28))
    create_other_organization_result

    get work_results_path, params: { fixed_at: "2015-02-28" }

    assert_response :success
    assert_not_includes response.body, homes(:home_other_org).name
  end

  private

  def create_other_organization_result
    WorkResult.find_or_create_by!(work: works(:work_other_org), worker: workers(:worker_other_org)) do |result|
      result.hours = 4
    end
  end
end
