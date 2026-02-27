require "test_helper"

class QrLoginFlowTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  test "QR login flow: create -> approve(scan) -> consume(login)" do
    freeze_time Time.current do
      pc     = open_session
      mobile = open_session
      user = users(:users1)

      # 1) PCがQRセッションを作る（create）
      pc.post sessions_qr_login_index_path, headers: { "ACCEPT" => "application/json" }
      pc.assert_response :success

      create_json = JSON.parse(pc.response.body)
      token = create_json["token"]
      assert token.present?

      qr = QrLoginSession.find_by!(token: token)
      assert_equal "pending", qr.status
      assert qr.expires_at > Time.current

      # 2) スマホがスキャンして approve（scan）
      #    controller側は @data[:type] / @data[:value] を見る実装なので payloadに合わせる
      payload = { type: "session", value: token, version: 1 }

      called = false
      QrLoginChannel.stub(:broadcast_to, ->(tok, data) {
        called = true
        assert_equal token, tok
        assert_equal({ type: "approved" }, data)
      }) do
        mobile.post(
          personal_information_scans_path(personal_information_token: user.token),
          params: { payload: payload }.to_json,
          headers: {
            "CONTENT_TYPE" => "application/json",
            "ACCEPT" => "application/json"
          }
        )
      end

      assert called, "QrLoginChannel.broadcast_to が呼ばれている"
      mobile.assert_response :ok

      scan_json = JSON.parse(mobile.response.body)
      assert_equal "ack", scan_json["action"]

      qr.reload
      assert_equal "approved", qr.status
      assert_equal user.id, qr.user_id

      # 3) PCがconsumeしてログイン確定（consume）
      pc.post consume_sessions_qr_login_path(token), headers: { "ACCEPT" => "application/json" }
      pc.assert_response :success

      consume_json = JSON.parse(pc.response.body)
      assert_equal true, consume_json["ok"]
      assert_equal "redirect", consume_json["action"]

      qr.reload
      assert_equal "consumed", qr.status
      assert_not_nil qr.consumed_at

      # PC側のセッションに user_id が入ったこと（ログイン成立）
      assert_equal user.id, pc.request.session[:user_id]
    end
  end
end
