require 'test_helper'

class PersonalInformations::SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(予定)" do
    get personal_information_schedules_path(personal_information_token: @user.token)
    assert_response :success
  end
end
