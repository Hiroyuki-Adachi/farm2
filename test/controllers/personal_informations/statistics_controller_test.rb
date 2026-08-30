require 'test_helper'

class PersonalInformations::StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(集計)" do
    systems(:s2015).update!(term_name: "第15期")

    get personal_information_statistics_path(personal_information_token: @user.token)

    assert_response :success
    labels = JSON.parse(css_select("input#chart1_labels").first["value"])
    assert_includes labels, "第15期"
  end
end
