require 'test_helper'

class StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "統計情報一覧" do
    get statistics_path
    assert_response :success
  end

  test "統計グラフは年度名を表示する" do
    systems(:s2015).update!(term_name: "第15期")

    [tab1_statistics_path(format: :json), tab2_statistics_path(format: :json), tab3_statistics_path(format: :json)].each do |path|
      get path

      assert_response :success
      assert_includes @response.parsed_body.dig("data", "labels"), "第15期"
    end
  end

  test "統計情報一覧(利用者)" do
    login_as(users(:user_user))
    get statistics_path
    assert_response :error
  end
end
