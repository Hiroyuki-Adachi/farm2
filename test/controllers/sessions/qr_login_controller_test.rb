require "test_helper"

class Sessions::QrLoginControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  test "QRコードログイン" do
    freeze_time Time.current do
      assert_difference "QrLoginSession.count", +1 do
        post sessions_qr_login_index_path, headers: { "ACCEPT" => "application/json" }
      end

      assert_response :success
      json = response.parsed_body

      assert json["token"].present?
      assert json["expires_at"].present?

      qr = QrLoginSession.find_by!(token: json["token"])
      assert_in_delta 5.minutes.from_now.to_i, qr.expires_at.to_i, 2
    end
  end

  test "QRコード生成(正常)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 5.minutes.from_now)

      get qrcode_sessions_qr_login_path(qr.token)

      assert_response :success
      assert_includes response.media_type, "image/svg+xml"
      assert_includes response.body, "<svg"
    end
  end

  test "QRコード生成(期限切れ)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 1.minute.ago)

      get qrcode_sessions_qr_login_path(qr.token)

      assert_response :gone
    end
  end

  test "QRコード消費(期限切れ)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :approved, user_id: 1, expires_at: 1.minute.ago)

      post consume_sessions_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :gone
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end

  test "QRコード消費(未承認)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 5.minutes.from_now)

      post consume_sessions_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :conflict
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end

  test "QRコード消費(ユーザーが見つからない)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: -999_999, # 存在しないIDにする
        expires_at: 5.minutes.from_now
      )

      post consume_sessions_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :unprocessable_content
      json = response.parsed_body
      assert_equal false, json["ok"]

      qr.reload
      assert_equal "approved", qr.status # consumeされてないこと
      assert_nil qr.consumed_at
    end
  end

  test "QRコード消費(正常)" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      post consume_sessions_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :success
      json = response.parsed_body
      assert_equal true, json["ok"]
      assert_equal "redirect", json["action"]
      assert_equal menu_index_path, json["url"]

      qr.reload
      assert_equal "consumed", qr.status
      assert_not_nil qr.consumed_at

      # IntegrationTestでは session をこう見るのが一番確実
      assert_equal user.id, @request.session[:user_id]
    end
  end

  test "QRコード消費(すでに使用済み)" do
    freeze_time Time.current do
      user = users(:users1)

      qr = QrLoginSession.create!(
        status: :consumed,
        user_id: user.id,
        expires_at: 5.minutes.from_now,
        consumed_at: 1.minute.ago
      )

      post consume_sessions_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :conflict
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end
end
