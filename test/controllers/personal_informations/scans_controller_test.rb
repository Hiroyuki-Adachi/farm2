require "test_helper"

class PersonalInformations::ScansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @land = lands(:lands1)
  end

  test "QR(スキャン画面)" do
    get new_personal_information_scan_path(
      personal_information_token: @user.token
    )
    assert_response :success
  end

  test "QR(スキャン結果)(圃場)(OK)" do
    params = {
      type: "lands",
      value: @land.uuid,
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :success

    body = JSON.parse(@response.body)
    assert_equal 'redirect', body['action']
    assert_equal personal_information_land_path(personal_information_token: @user.token, id: @land.id), body["url"]
  end

  test "QR(スキャン結果)(ERROR)" do
    params = {
      type: 'error',
      value: @land.uuid,
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :bad_request
  end

  test "QR(スキャン結果)(圃場)(Not Found)" do
    params = {
      type: 'lands',
      value: 'abcd',
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :not_found
  end

  test "QRコードスキャン(セッショントークンが見つからない場合)" do
    params = {
      type: 'session',
      value: 'no-such-token',
      version: 1
    }

    post personal_information_scans_path(
      personal_information_token: @user.token
    ), params: { payload: params.to_json }, as: :json
    assert_response :not_found
  end

  test "QRコードスキャン(使用できないセッショントークン)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 1.minute.ago)

      params = {
        type: 'session',
        value: qr.token,
        version: 1
      }

      post personal_information_scans_path(
        personal_information_token: @user.token
      ), params: { payload: params.to_json }, as: :json

      assert_response :unprocessable_content

      qr.reload
      assert_nil qr.user_id
      assert_equal "pending", qr.status
    end
  end

  test "QRコードスキャン(成功)" do
    freeze_time Time.current do
      qr = QrLoginSession.create!(status: :pending, expires_at: 5.minutes.from_now)

      called = false
      QrLoginChannel.stub(:broadcast_to, ->(token, payload) {
        called = true
        assert_equal qr.token, token
        assert_equal({ type: "approved" }, payload)
      }) do
        params = {
          type: 'session',
          value: qr.token,
          version: 1
        }

        post personal_information_scans_path(
          personal_information_token: @user.token
        ), params: { payload: params.to_json }, as: :json
      end

      assert called, "QrLoginChannel.broadcast_to が呼び出される"

      assert_response :ok

      qr.reload
      assert_equal @user.id, qr.user_id
      assert_equal "approved", qr.status
    end
  end
end
