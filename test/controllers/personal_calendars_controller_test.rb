require 'test_helper'

class PersonalCalendarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人カレンダー" do
    get personal_calendar_path(token: @user.token)
    assert response.header["Content-Type"].match(%r{^text/calendar})
  end
end
