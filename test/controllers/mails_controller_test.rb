require "test_helper"

class MailsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper  # ActionMailerのヘルパーをインクルード
  setup do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('1.1.1.1')
    @user = users(:users1)
  end

  test "メールアドレス入力(ローカル)" do
    ActionDispatch::Request.any_instance.stubs(:remote_ip).returns('192.168.0.1')
    get :new
    assert_redirected_to root_path
  end

  test "メールアドレス入力(リモート)" do
    get :new
    assert_response :success
  end

  test "メールアドレス登録(正規)" do
    assert_emails 1 do
      assert_difference('IpList.count') do
        post :create, params: {mail: @user.mail}
      end
    end
    assert_response :success

    ip = IpList.last
    assert_equal ip.mail, @user.mail
    assert_equal ip.created_by, @user.id
    assert_equal ip.ip_address, '1.1.1.1'
    assert ip.white_flag
    assert_operator ip.mail_confirmation_expired_at, :>, Time.current
  end

  test "メールアドレス登録(非正規)" do
    assert_emails 0 do
      assert_difference('IpList.count') do
        post :create, params: {mail: 'error@example.com'}
      end
    end
    assert_response :success

    ip = IpList.last
    assert_equal ip.ip_address, '1.1.1.1'
    assert_not ip.white_flag
    assert_equal ip.block_count, 1
  end
end
