require 'test_helper'

class Calendars::ExcelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "カレンダーExcel出力" do
    get calendars_excels_path(months: 3)

    assert_response :success
    assert_equal Mime[:xlsx].to_s, response.media_type
    assert_match(/attachment; filename=/, response.headers["Content-Disposition"])
    assert_not_empty response.body
  end

  test "カレンダーExcel出力(月数不正)" do
    get calendars_excels_path(months: 999)

    assert_response :bad_request
  end
end
