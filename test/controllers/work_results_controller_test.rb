require 'test_helper'
require 'csv'

class WorkResultsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "世帯別日当一覧" do
    systems(:s2015).update!(term_name: "第15期")
    create_other_organization_result

    get work_results_path
    assert_response :success
    assert_select "h1", text: "世帯別日当一覧(第15期)"
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

  test "未確定の日当一覧で金額ゼロの明細をハイライトしCSVに出力しない" do
    results = target_results
    zero_result = results.first
    zero_result.update!(hours: 0)
    expected = results.reload.reject(&:zero_amount?)

    get work_results_path
    assert_response :success
    assert_select "tr.tr-detail.table-warning", count: results.count(&:zero_amount?)
    assert_select "a[href=?]", work_results_path(format: :csv)

    get work_results_path(format: :csv)
    assert_response :success
    rows = parse_csv(response.body)
    assert_equal expected.size, rows.size
    assert(rows.none? { |row| row[8].to_d.zero? })
  end

  test "確定日当一覧で金額ゼロの明細をハイライトしCSVに出力しない" do
    fixed_at = Date.new(2015, 2, 28)
    zero_result = target_results.first
    zero_result.work.update!(fixed_at: fixed_at)
    work_results = zero_result.work.work_results.to_a
    work_results.each { |r| r.update!(fixed_hours: r.hours, fixed_price: 1000, fixed_amount: 1000 * r.hours) }
    zero_result.reload.update!(fixed_price: 0, fixed_amount: 0)
    expected_count = WorkResult.for_organization(users(:users1).organization)
      .by_home_for_fix(users(:users1).term, fixed_at).count { |r| !r.zero_amount? }

    get work_results_path, params: { fixed_at: "2015-02-28" }
    assert_response :success
    assert_select "tr.tr-detail.table-warning", count: 1
    assert_select "a[href=?]", work_results_path(fixed_at: "2015-02-28", format: :csv)

    get work_results_path(fixed_at: "2015-02-28", format: :csv)
    assert_response :success
    rows = parse_csv(response.body)
    assert_equal expected_count, rows.size
    assert(rows.none? { |row| row[8].to_d.zero? })
  end

  private

  def target_results
    WorkResult.for_organization(users(:users1).organization).by_home(users(:users1).term)
  end

  def parse_csv(body)
    CSV.parse(body.force_encoding(Encoding::Windows_31J).encode(Encoding::UTF_8)).drop(1)
  end

  def create_other_organization_result
    WorkResult.find_or_create_by!(work: works(:work_other_org), worker: workers(:worker_other_org)) do |result|
      result.hours = 4
    end
  end
end
