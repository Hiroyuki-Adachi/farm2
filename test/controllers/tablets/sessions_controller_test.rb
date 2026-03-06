require "test_helper"

class Tablets::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ログイン画面(表示)" do
    get new_tablets_session_path
    assert_response :success
    assert_select "h2", "タブレットログイン"
  end
end
