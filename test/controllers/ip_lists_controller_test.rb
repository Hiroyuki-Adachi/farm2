require "test_helper"

class IpListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_line_id_already_exists)
    @ip_address = '5.5.5.5'
    @original = LineHookService.method(:push_message)
    IpListsController.any_instance.stubs(:current_user).returns(@user)
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end

  test "ID認証画面(ブラックリスト)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '4.4.4.4' }
    assert_response :service_unavailable
  end

  test "ID認証画面(ホワイトリスト)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '3.3.3.3' }
    assert_redirected_to root_path
  end

  test "ID認証画面(ローカルアドレス)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '127.0.0.1' }
    assert_redirected_to root_path
  end

  test "ID認証画面" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_response :success
  end

  test "ID認証画面(LINE送信)" do
    LineHookService.define_singleton_method(:push_message) do |*_args|
      Net::HTTPOK.new("1.1", "200", "OK")
    end
    assert_difference('IpList.count') do
      post ip_lists_path, params: {login_name: @user.login_name}, headers: { 'REMOTE_ADDR' => @ip_address }
    end

    ip = IpList.last
    assert_equal @user.login_name, ip.mail
    assert_equal @ip_address, ip.ip_address
    assert_equal true, ip.white_flag
    assert_redirected_to edit_ip_list_path(ip)
  end

  test "ID認証画面(LINE送信失敗)" do
    LineHookService.define_singleton_method(:push_message) do |*_args|
      Net::HTTPServerError.new(1.0, "500", "Error")
    end

    assert_no_difference('IpList.count') do
      post ip_lists_path, params: {login_name: @user.login_name}, headers: { 'REMOTE_ADDR' => @ip_address }
    end

    assert_response :service_unavailable
  end

  test "ID認証画面(LINE未登録)" do
    @user.update(line_id: '')
    assert_no_difference('IpList.count') do
      post ip_lists_path, params: {login_name: @user.login_name}, headers: { 'REMOTE_ADDR' => @ip_address }
    end

    assert_response :service_unavailable
  end

  test "ID認証画面(LINE送信)(未登録)" do
    assert_difference('IpList.count') do
      post ip_lists_path, params: {login_name: 'invalid_name'}, headers: { 'REMOTE_ADDR' => @ip_address }
    end
    assert_response :service_unavailable

    ip = IpList.last
    assert_equal @ip_address, ip.ip_address
    assert_equal false, ip.white_flag
  end

  test "ID認証画面(TOTP認証)" do
    @user.update(otp_enabled: true, line_id: '')

    assert_difference('IpList.count') do
      post ip_lists_path, params: {login_name: @user.login_name}, headers: { 'REMOTE_ADDR' => @ip_address }
    end

    ip = IpList.last
    assert_equal @user.login_name, ip.mail
    assert_equal @ip_address, ip.ip_address
    assert_equal true, ip.white_flag
    assert_redirected_to edit_ip_list_path(ip)
  end

  test "番号認証(表示)(ホワイト登録済)" do
    ip = ip_lists(:ip_white)
    get edit_ip_list_path(id: ip.id), headers: { 'REMOTE_ADDR' => @ip_address }
    assert_response :service_unavailable
  end

  test "番号認証(表示)(ブラック登録済)" do
    ip = ip_lists(:ip_black)
    get edit_ip_list_path(id: ip.id), headers: { 'REMOTE_ADDR' => @ip_address }
    assert_response :service_unavailable
  end

  test "番号認証(表示)" do
    ip = IpList.white_ip!(@ip_address, @user)
    get edit_ip_list_path(id: ip.id), headers: { 'REMOTE_ADDR' => @ip_address }
    assert_response :success
  end

  test "番号認証(LINE認証)" do
    ip = IpList.white_ip!(@ip_address, @user)
    patch ip_list_path(id: ip.id), params: {token: ip.token}, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to menu_index_path

    ip.reload
    assert_not_nil ip.expired_on
    assert_equal @user.id, ip.created_by
    assert_equal @user.id, session[:user_id]
  end

  test "番号認証(LINE認証)(エラー)" do
    ip = IpList.white_ip!(@ip_address, @user)
    ip.token = "123456"
    ip.save!

    patch ip_list_path(id: ip.id), params: {token: '654321'}, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to new_ip_list_path

    ip.reload
    assert_nil ip.expired_on
    assert_nil session[:user_id]
  end

  test "番号認証(TOTP認証)" do
    @user.update(otp_enabled: true, line_id: '')
    ip = IpList.white_ip!(@ip_address, @user)

    totp = mock("totp")
    totp.expects(:verify)
        .with("123456", has_entries(drift_behind: 30, drift_ahead: 30))
        .returns(true)
    @user.stubs(:totp).returns(totp)

    ip.stubs(:created_user).returns(@user)
    IpList.stubs(:find_valid).returns(ip)

    patch ip_list_path(id: ip.id), params: { token: '123456' }, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to menu_index_path

    ip.reload
    assert_not_nil ip.expired_on
    assert_equal @user.id, ip.created_by
    assert_equal @user.id, session[:user_id]
  end

  test "番号認証(TOTP認証)(エラー)" do
    @user.update(otp_enabled: true, line_id: '')
    ip = IpList.white_ip!(@ip_address, @user)

    totp = mock("totp")
    totp.expects(:verify)
        .with("123456", has_entries(drift_behind: 30, drift_ahead: 30))
        .returns(false)
    @user.stubs(:totp).returns(totp)

    ip.stubs(:created_user).returns(@user)
    IpList.stubs(:find_valid).returns(ip)

    patch ip_list_path(id: ip.id), params: { token: '123456' }, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to new_ip_list_path

    ip.reload
    assert_nil ip.expired_on
    assert_nil session[:user_id]
  end
end
