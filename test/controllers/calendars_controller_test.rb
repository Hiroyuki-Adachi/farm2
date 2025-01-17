require 'test_helper'

class CalendarsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "カレンダー" do
    get calendars_path
    assert_response :success
  end

  test "カレンダー(管理者以外)" do
    login_as(users(:user_checker))
    get calendars_path
    assert_response :error
  end
end
