require "test_helper"

class Gaps::AccidentsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @accident = accidents(:accident1)
  end

  test "GAPヒヤリハット(一覧)" do
    get :index
    assert_response :success
  end

  test "GAPヒヤリハット登録(表示)" do
    get :new
    assert_response :success
  end

  test "GAPヒヤリハット登録(実行)" do
    create_data = {
      location: "(35.472840, 133.050677)",
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
      post :create, params: {accident: create_data}
    end
    assert_redirected_to gaps_accidents_path
  end

  test "GAPヒヤリハット(照会)" do
    get :show, params: {id: @accident}
    assert_response :success
  end

  test "GAPヒヤリハット変更(表示)" do
    get :edit, params: {id: @accident}
    assert_response :success
  end

  test "GAPヒヤリハット変更(実行)" do
    assert_no_difference('Accident.count') do
      put :update, params: {id: @accident, accident: {content: "備考を変更"}}
    end
    assert_redirected_to gaps_accidents_path
  end

  test "GAPヒヤリハット削除" do
    assert_difference('Accident.count', -1) do
      delete :destroy, params: {id: @accident}
    end
    assert_redirected_to gaps_accidents_path
  end
end
