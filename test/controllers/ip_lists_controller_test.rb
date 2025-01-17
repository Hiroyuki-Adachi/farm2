require "test_helper"

class IpListsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @ip_address = '5.5.5.5'
  end

  test "メール送信画面(ブラックリスト)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '4.4.4.4' }
    assert_response :service_unavailable
  end

  test "メール送信画面(ホワイトリスト)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '3.3.3.3' }
    assert_redirected_to root_path
  end

  test "メール送信画面(ローカルアドレス)" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => '127.0.0.1' }
    assert_redirected_to root_path
  end

  test "メール送信画面" do
    get new_ip_list_path, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_response :success
  end

  test "メール送信画面(送信)" do
    assert_difference('IpList.count') do
      post ip_lists_path, params: {mail: @user.mail}, headers: { 'REMOTE_ADDR' => @ip_address }
    end
    ip = IpList.last
    assert_equal @user.mail, ip.mail
    assert_equal @ip_address, ip.ip_address
    assert_equal true, ip.white_flag
    assert_redirected_to edit_ip_list_path(ip)
  end

  test "メール送信画面(送信)(未登録)" do
    assert_difference('IpList.count') do
      post ip_lists_path, params: {mail: 'error@example.com'}, headers: { 'REMOTE_ADDR' => @ip_address }
    end
    assert_response :service_unavailable

    ip = IpList.last
    assert_equal @ip_address, ip.ip_address
    assert_equal false, ip.white_flag
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

  test "番号認証(認証)" do
    ip = IpList.white_ip!(@ip_address, @user)
    patch ip_list_path(id: ip.id), params: {token: ip.token}, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to menu_index_path

    ip.reload
    assert_not_nil ip.expired_on
    assert_equal @user.id, ip.created_by
    assert_equal @user.id, session[:user_id]
  end

  test "番号認証(認証)(エラー)" do
    ip = IpList.white_ip!(@ip_address, @user)
    ip.token = "123456"
    ip.save!

    patch ip_list_path(id: ip.id), params: {token: '654321'}, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to new_ip_list_path

    ip.reload
    assert_nil ip.expired_on
    assert_nil session[:user_id]
  end
end
