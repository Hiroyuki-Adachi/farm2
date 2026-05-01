require "test_helper"

class Statistics::AreasControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "集計対象の作業種別を指定順に表示する" do
    work_kinds(:work_kind_taue).update!(aggregation_flag: true)
    work_kinds(:work_kinds2).update!(aggregation_flag: true)
    work_kinds(:work_kind_shirokaki).update!(aggregation_flag: false)

    get statistics_areas_path

    assert_response :success
    assert_select "input[type=radio][name=work_kind_id][value=?]", work_kinds(:work_kinds2).id.to_s, 1
    assert_select "input[type=radio][name=work_kind_id][value=?]", work_kinds(:work_kind_taue).id.to_s, 1
    assert_select "input[type=radio][name=work_kind_id][value=?]", work_kinds(:work_kind_shirokaki).id.to_s, 0
    assert_match(/#{Regexp.escape(work_kinds(:work_kinds2).name)}.*#{Regexp.escape(work_kinds(:work_kind_taue).name)}/m, @response.body)
    assert_select "input[type=radio][name=work_kind_id][checked=checked][value=?]", work_kinds(:work_kinds2).id.to_s, 1
    assert_select "input[type=submit][value=?]", "表示", 1
    assert_select "canvas#chart[data-labels][data-values][data-title=?]", work_kinds(:work_kinds2).name, 1
    assert_select "input#current_controller[value=?]", "statistics_areas", 1
  end

  test "選択された作業種別を保持する" do
    work_kinds(:work_kind_taue).update!(aggregation_flag: true)
    work_kinds(:work_kinds2).update!(aggregation_flag: true)

    get statistics_areas_path, params: {work_kind_id: work_kinds(:work_kind_taue).id}

    assert_response :success
    assert_select "input[type=radio][name=work_kind_id][checked=checked][value=?]", work_kinds(:work_kind_taue).id.to_s, 1
  end

  test "選択された作業種別のグラフデータをJSONで返す" do
    work_kinds(:work_kind_taue).update!(aggregation_flag: true)

    get statistics_areas_path(format: :json), params: {work_kind_id: work_kinds(:work_kind_taue).id}

    assert_response :success
    json = JSON.parse(@response.body)
    system = System.find_by!(term: users(:users1).term, organization_id: users(:users1).organization_id)
    assert_equal system.get_prev_terms(10).sort, json["labels"]
    assert_equal json["labels"].length, json["values"].length
    assert_equal work_kinds(:work_kind_taue).name, json["title"]
  end
end
