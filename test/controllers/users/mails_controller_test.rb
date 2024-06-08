require "test_helper"

class Users::MailsControllerTest < ActionController::TestCase
  include ActionMailer::TestHelper # ActionMailerのヘルパーをインクルード

  setup do
    setup_ip
  end

  test "IPアドレス設定(表示)" do
    get :new
    assert_response :success
  end

  test "IPアドレス設定(登録)" do
    assert_emails 1 do
      post :create, params: { user: { mail: 'new_email@example.com' } }
    end
    assert_redirected_to menu_index_path
  end
end
