require "test_helper"

class Gaps::AccidentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @accident = accidents(:accident1)
  end

  test "GAPヒヤリハット(一覧)" do
    get gaps_accidents_path
    assert_response :success
  end

  test "GAPヒヤリハット登録(表示)" do
    get new_gaps_accident_path
    assert_response :success
  end

  test "GAPヒヤリハット登録(実行)" do
    create_data = {
      location: "(35.472841, 133.050677)",
      investigated_on: "2015-12-30",
      content: "内容",
      problem: "問題点の考察",
      result: "改善の結果",
      solving: "問題解決の考察",
      accident_type_id: 1,
      audience_id: 7,
      work_id: 1493,
      investigator_id: 1
    }
    assert_difference('Accident.count') do
      post gaps_accidents_path, params: {accident: create_data}
    end
    assert_redirected_to gaps_accidents_path

    created_accident = Accident.last
    create_data.each do |key, value|
      if key == :location
        location = created_accident.send(key)
        assert_equal value, "(#{location.x}, #{location.y})"
      elsif key == :investigated_on
        assert_equal value, created_accident.send(key).strftime('%Y-%m-%d')
      else
        assert_equal value, created_accident.send(key)
      end
    end
  end

  test "GAPヒヤリハット(照会)" do
    get gaps_accident_path(id: @accident)
    assert_response :success
  end

  test "GAPヒヤリハット変更(表示)" do
    get edit_gaps_accident_path(id: @accident)
    assert_response :success
  end

  test "GAPヒヤリハット変更(実行)" do
    content = "備考を変更"
    assert_no_difference('Accident.count') do
      put gaps_accident_path(id: @accident), params: {accident: {content: content}}
    end
    assert_redirected_to gaps_accidents_path

    @accident.reload
    assert_equal content, @accident.content
  end

  test "GAPヒヤリハット削除" do
    assert_difference('Accident.count', -1) do
      delete gaps_accident_path(id: @accident)
    end
    assert_redirected_to gaps_accidents_path

    assert_nil Accident.find_by(id: @accident.id)
  end
end
