require 'test_helper'

class PersonalCalendarsControllerTest < ActionDispatch::IntegrationTest
  include Rails.application.routes.url_helpers

  setup do
    @user = users(:users1)
  end

  test "カレンダーに必要な作業データが含まれている" do
    work = works(:works1)
    body = nil
    travel_to Time.zone.local(2015, 3, 22) do
      get personal_calendar_path(token: @user.token)
      body = response.body
    
      assert_response :success
      assert_match %r{^text/calendar}, response.header["Content-Type"]
    end

    flattened_body = body.gsub("\r\n", '').gsub(/\s/, '')
    assert_includes body, "BEGIN:VCALENDAR"
    assert_includes flattened_body, work.name
    assert_includes flattened_body, work.remarks
    assert_includes flattened_body, personal_information_work_url(personal_information_token: @user.token, id: work.id)
    assert_includes body, "SUMMARY:"  
    assert_includes body, "END:VCALENDAR"
  end

  test "カレンダーに必要な予定データが含まれている" do
    schedule = schedules(:schedule1)
    body = nil
    travel_to schedule.worked_at - 1.day do
      get personal_calendar_path(token: @user.token)
      body = response.body
    
      assert_response :success
      assert_match %r{^text/calendar}, response.header["Content-Type"]
    end

    flattened_body = body.gsub("\r\n", '').gsub(/\s/, '')
    assert_includes body, "BEGIN:VCALENDAR"
    assert_includes flattened_body, schedule.name
    assert_includes body, "END:VCALENDAR"
  end

  test "過去削除有効の予定データは含まれない" do
    schedule = schedules(:schedule1)
    body = nil
    travel_to schedule.worked_at + 1.day do
      get personal_calendar_path(token: @user.token)
      body = response.body
    
      assert_response :success
      assert_match %r{^text/calendar}, response.header["Content-Type"]
    end

    flattened_body = body.gsub("\r\n", '').gsub(/\s/, '')
    assert_includes body, "BEGIN:VCALENDAR"
    assert_not_includes flattened_body, schedule.name
    assert_includes body, "END:VCALENDAR"
  end

  test "過去削除無効の予定データは含まれる" do
    schedule = schedules(:schedule1)
    schedule.calendar_remove_flag = false
    schedule.save!

    body = nil
    travel_to schedule.worked_at + 1.day do
      get personal_calendar_path(token: @user.token)
      body = response.body
    
      assert_response :success
      assert_match %r{^text/calendar}, response.header["Content-Type"]
    end

    flattened_body = body.gsub("\r\n", '').gsub(/\s/, '')
    assert_includes body, "BEGIN:VCALENDAR"
    assert_includes flattened_body, schedule.name
    assert_includes body, "END:VCALENDAR"
  end

  test "無効なトークンはエラーを返す" do
    get personal_calendar_path(token: "invalidtoken")
    assert_response :service_unavailable
  end
end
