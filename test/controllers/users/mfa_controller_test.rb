require "test_helper"
require "rotp"

class Users::MfaControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    Users::MfaController.any_instance.stubs(:current_user).returns(@user)
  end

  test "TOTP編集(TOTP有効)" do
    otp_secret = "old_secret"
    @user.update(otp_enabled: true, otp_secret: otp_secret)
    get edit_users_mfa_path
    assert_response :success

    assert_equal otp_secret, @user.reload.otp_secret
  end

  test "TOTP編集(TOTP無効)" do
    @user.update(otp_enabled: false, otp_secret: nil)

    # edit で provisioning_uri を描画するので、totp/provisioning_uri を用意
    totp = mock("totp")
    totp.expects(:provisioning_uri).with(kind_of(String)).returns("otpauth://totp/EXAMPLE")
    @user.stubs(:totp).returns(totp)

    get edit_users_mfa_path
    assert_response :success
    assert_includes @response.body, "<svg" # QRコードが描画されている

    @user.reload
    assert_not_nil @user.otp_secret
  end

  test "TOTP確認(コードが正しい)" do
    totp = mock("totp")
    totp.expects(:verify).with("123456", has_entries(drift_behind: 30, drift_ahead: 30)).returns(true)
    @user.stubs(:totp).returns(totp)
    @user.expects(:enable_totp!).returns(true)

    patch users_mfa_path, params: { otp: "123456" }
    assert_redirected_to menu_index_path
  end

  test "TOTP確認(コードが間違い)" do
    totp = mock("totp")
    totp.expects(:verify).with("000000", has_entries(drift_behind: 30, drift_ahead: 30)).returns(false)
    totp.expects(:provisioning_uri).with(@user.worker.name).returns("otpauth://totp/retry")
    @user.stubs(:totp).returns(totp)

    patch users_mfa_path, params: { otp: "000000" }
    assert_response :unprocessable_content
    assert_includes @response.body, "<svg" # QRコードが描画されている
  end

  test "TOTP解除" do
    @user.expects(:destroy_totp!).returns(true)

    delete users_mfa_path
    assert_redirected_to edit_users_mfa_path
  end
end
