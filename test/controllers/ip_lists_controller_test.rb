require "test_helper"

class IpListsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = nil
    @user = users(:users1)
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('5.5.5.5')
  end

  test "メール送信画面(ブラックリスト)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('4.4.4.4')
    get :new
    assert_response :service_unavailable
  end

  test "メール送信画面(ホワイトリスト)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('3.3.3.3')
    get :new
    assert_redirected_to root_path
  end

  test "メール送信画面(ローカルアドレス)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('127.0.0.1')
    get :new
    assert_redirected_to root_path
  end

  test "メール送信画面" do
    get :new
    assert_response :success
  end

  test "メール送信画面(送信)" do
    assert_difference('IpList.count') do
      post :create, params: {mail: @user.mail}
    end
    ip = IpList.last
    assert_equal @user.mail, ip.mail
    assert_equal '5.5.5.5', ip.ip_address
    assert_equal true, ip.white_flag
    assert_redirected_to edit_ip_list_path(ip)
  end

  test "メール送信画面(送信)(未登録)" do
    assert_difference('IpList.count') do
      post :create, params: {mail: 'error@example.com'}
    end
    assert_response :service_unavailable

    ip = IpList.last
    assert_equal '5.5.5.5', ip.ip_address
    assert_equal false, ip.white_flag
  end

  test "番号認証(表示)(ホワイト登録済)" do
    ip = ip_lists(:ip_white)
    get :edit, params: {id: ip.id}
    assert_response :service_unavailable
  end

  test "番号認証(表示)(ブラック登録済)" do
    ip = ip_lists(:ip_black)
    get :edit, params: {id: ip.id}
    assert_response :service_unavailable
  end

  test "番号認証(表示)" do
    ip = IpList.white_ip!('5.5.5.5', @user)
    get :edit, params: {id: ip.id}
    assert_response :success
  end

  test "番号認証(認証)" do
    ip = IpList.white_ip!('5.5.5.5', @user)
    patch :update, params: {id: ip.id, token: ip.token}
    assert_not_nil ip.reload.expired_on
    assert_redirected_to menu_index_path
    assert @user.id, session[:user_id]
  end

  test "番号認証(認証)(エラー)" do
    ip = IpList.white_ip!('5.5.5.5', @user)
    ip.token = "123456"
    ip.save!

    patch :update, params: {id: ip.id, token: '654321'}
    assert_nil ip.reload.expired_on
    assert_redirected_to new_ip_list_path
    assert_nil session[:user_id]
  end
end
