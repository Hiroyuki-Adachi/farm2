require 'test_helper'

class CalendarWorkKindsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @calendar_term = 2014
    @work_kind = work_kinds(:work_kind_taue)
    @text_color = "#123456"
  end

  test "カレンダー制御" do
    get calendar_work_kinds_path
    assert_response :success
  end

  test "カレンダー制御(管理者以外)" do
    login_as(users(:user_checker))
    get calendar_work_kinds_path
    assert_response :error
  end

  test "カレンダー制御(登録)" do
    assert_difference('CalendarWorkKind.count') do
      post calendar_work_kinds_path, params: {
        calendar_term: @calendar_term,
        work_kind_id: [@work_kind.id],
        text_color: {@work_kind.id => @text_color}
      }
    end
    assert_redirected_to calendars_path

    calendar_work_kind = CalendarWorkKind.last
    assert_equal @user.id, calendar_work_kind.user_id
    assert_equal @work_kind.id, calendar_work_kind.work_kind_id
    assert_equal @text_color, calendar_work_kind.text_color
  end
end
