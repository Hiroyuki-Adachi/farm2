require 'test_helper'

class PersonalCalendarsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

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
    work = works(:works1)
  
    assert_response :success
    assert_match %r{^text/calendar}, response.header["Content-Type"]
  
    flattened_body = body.gsub(/\r\n/, '').gsub(/\s/, '')
    assert_includes body, "BEGIN:VCALENDAR"
    assert_includes flattened_body, schedules(:schedule1).name
    assert_includes flattened_body, work.remarks
    assert_includes flattened_body, personal_information_work_url(personal_information_token: @user.token, id: work.id)
    assert_includes body, "SUMMARY:"  
    assert_includes body, "END:VCALENDAR"
  end

  test "無効なトークンはエラーを返す" do
    get personal_calendar_path(token: "invalidtoken")
    assert_response :service_unavailable
  end
end
