require "test_helper"

class Tablets::MenuControllerTest < ActionDispatch::IntegrationTest
  setup do
    user = users(:users1)
    qr_login_session = QrLoginSession.create!(
      status: :approved,
      user_id: user.id,
      expires_at: 5.minutes.from_now
    )

    post consume_sessions_qr_login_path(qr_login_session.token),
         params: { redirect_to: tablets_menu_index_path },
         headers: { "ACCEPT" => "application/json" }
  end

  test "ログアウトリンクはTurboプリフェッチを無効にする" do
    get tablets_menu_index_path

    assert_response :success
    assert_select %(a[href="#{new_tablets_session_path}"][data-turbo-prefetch="false"]) do |links|
      assert_includes links.first.text, "ログアウト"
    end
  end
end
