require 'test_helper'

class CalendarWorkKindsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @calendar_term = 2014
    @work_kind = work_kinds(:work_kind_taue)
    @text_color = "#123456"
  end

  test "カレンダー制御" do
    get :index
    assert_response :success
  end

  test "カレンダー制御(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :index
    assert_response :error
  end

  test "カレンダー制御(登録)" do
    assert_difference('CalendarWorkKind.count') do
      post :create, params: {calendar_term: @calendar_term,
                             work_kind_id: [@work_kind.id],
                             text_color: {@work_kind.id => @text_color}}
    end

    assert_redirected_to calendars_path
  end
end
