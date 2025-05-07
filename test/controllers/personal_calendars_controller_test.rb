require 'test_helper'

class PersonalCalendarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    travel_to Time.zone.local(2015, 3, 22)
  end

  teardown do
    travel_back
  end

  test "カレンダーに必要なデータが含まれている" do
    get personal_calendar_path(token: @user.token)
    body = response.body
  
    assert_response :success
    assert_match %r{^text/calendar}, response.header["Content-Type"]
  
    assert_includes body, "BEGIN:VEVENT"
    assert_includes body, schedules(:schedule1).name
    assert_includes body, works(:works1).remarks
    assert_includes body, "SUMMARY:"  
  end

  test "無効なトークンはエラーを返す" do
    get personal_calendar_path(token: "invalidtoken")
    assert_response :service_unavailable
  end
end
