require "test_helper"

class Tablets::SessionsControllerTest < ActionDispatch::IntegrationTest
  test "ログイン画面(表示)" do
    get new_tablets_session_path
    assert_response :success
    assert_select "h2", "タブレットログイン"
  end

  test "ログイン画面(パブリックIPはID確認へ)" do
    get new_tablets_session_path, headers: { "REMOTE_ADDR" => "1.1.1.1" }
    assert_redirected_to new_ip_list_path(return_to: tablets_menu_index_path)
  end

  test "ログイン画面(ブラックリストIPは拒否)" do
    get new_tablets_session_path, headers: { "REMOTE_ADDR" => "4.4.4.4" }
    assert_response :service_unavailable
  end
end
