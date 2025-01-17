require 'test_helper'

class PersonalInformations::StatisticsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(集計)" do
    get personal_information_statistics_path(personal_information_token: @user.token)
    assert_response :success
  end
end
