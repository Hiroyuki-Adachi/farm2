require "test_helper"

class Tablets::QrLoginControllerTest < ActionDispatch::IntegrationTest
  include ActiveSupport::Testing::TimeHelpers

  test "QRコードログイン(ホワイトリスト外/ブラックリストIPでも制限されない)" do
    freeze_time Time.current do
      assert_difference "QrLoginSession.count", +1 do
        post tablets_qr_login_index_path,
             headers: { "ACCEPT" => "application/json", "REMOTE_ADDR" => "4.4.4.4" }
      end

      assert_response :success
    end
  end

  test "QRコード生成(正常)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 5.minutes.from_now)

      get qrcode_tablets_qr_login_path(qr.token)

      assert_response :success
      assert_includes response.media_type, "image/svg+xml"
      assert_includes response.body, "<svg"
    end
  end

  test "QRコード生成(期限切れ)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(expires_at: 1.minute.ago)

      get qrcode_tablets_qr_login_path(qr.token)

      assert_response :gone
    end
  end

  test "QRコード消費(期限切れ)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :approved, user_id: 1, expires_at: 1.minute.ago)

      post consume_tablets_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :gone
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end

  test "QRコード消費(未承認)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 5.minutes.from_now)

      post consume_tablets_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :conflict
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end

  test "QRコード消費(正常, IP制限なしでTB固定ログインになる)" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      access_logger = Minitest::Mock.new
      access_logger.expect(:info, nil, ["TB-#{user.worker.name}"])

      Rails.application.config.stub(:access_logger, access_logger) do
        post consume_tablets_qr_login_path(qr.token),
             headers: { "ACCEPT" => "application/json", "REMOTE_ADDR" => "4.4.4.4" }
      end

      assert_response :success
      json = response.parsed_body
      assert_equal true, json["ok"]
      assert_equal tablets_menu_index_path, json["url"]
      assert_equal "TB", @request.session[:access_target]
      access_logger.verify
    end
  end

  test "QRコード消費(script_nameあり)" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      post consume_tablets_qr_login_path(qr.token),
           params: { redirect_to: tablets_menu_index_path },
           headers: { "ACCEPT" => "application/json" },
           env: { "SCRIPT_NAME" => "/farm2" }

      assert_response :success
      json = response.parsed_body
      assert_equal true, json["ok"]
      assert_equal "/farm2/tablets/menu", json["url"]
    end
  end

  test "QRコード消費(PC等の域外遷移先を指定してもタブレットメニューに固定される)" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      post consume_tablets_qr_login_path(qr.token),
           params: { redirect_to: menu_index_path },
           headers: { "ACCEPT" => "application/json" }

      assert_response :success
      json = response.parsed_body
      assert_equal true, json["ok"]
      assert_equal tablets_menu_index_path, json["url"]
      assert_equal "TB", @request.session[:access_target]
    end
  end

  test "QRコード消費(外部遷移先指定は拒否)" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      post consume_tablets_qr_login_path(qr.token),
           params: { redirect_to: "https://example.com/evil" },
           headers: { "ACCEPT" => "application/json" }

      assert_response :success
      json = response.parsed_body
      assert_equal true, json["ok"]
      assert_equal tablets_menu_index_path, json["url"]
    end
  end

  test "QRコード消費(ユーザーが見つからない)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: -999_999,
        expires_at: 5.minutes.from_now
      )

      post consume_tablets_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :unprocessable_content
      json = response.parsed_body
      assert_equal false, json["ok"]

      qr.reload
      assert_equal "approved", qr.status
      assert_nil qr.consumed_at
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

      post consume_tablets_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }

      assert_response :conflict
      json = response.parsed_body
      assert_equal false, json["ok"]
    end
  end

  test "TBログイン後にPC URLへ書き換えるとログアウトされる" do
    freeze_time Time.current do
      user = users(:users1)
      qr = QrLoginSession.create!(
        status: :approved,
        user_id: user.id,
        expires_at: 5.minutes.from_now
      )

      post consume_tablets_qr_login_path(qr.token), headers: { "ACCEPT" => "application/json" }
      assert_response :success
      assert_equal "TB", @request.session[:access_target]

      get menu_index_path
      assert_redirected_to root_path
      assert_nil @request.session[:user_id]
      assert_nil @request.session[:access_target]
    end
  end
end
