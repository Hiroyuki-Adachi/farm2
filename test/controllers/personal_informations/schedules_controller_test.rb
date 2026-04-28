require 'test_helper'

class PersonalInformations::SchedulesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(予定)" do
    get personal_information_schedules_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "個人情報(予定: 一般作業者にも人員保守リンクを表示)" do
    user = users(:user_user)

    get personal_information_schedules_path(personal_information_token: user.token)

    assert_response :success
    assert_select "a[href='#{personal_information_schedules_workers_path(personal_information_token: user.token)}']", "人員保守"
  end
end
