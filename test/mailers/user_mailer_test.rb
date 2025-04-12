require "test_helper"

class UserMailerTest < ActionMailer::TestCase
  test "メールアドレス認証" do
    user = users(:users1)
    user.mail = "new_user@example.com"
    user.save!
    email = UserMailer.email_confirmation(user)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [user.mail], email.to
  end

  test "IPアドレス認証" do
    ip = ip_lists(:ip_white)
    email = UserMailer.ip_confirmation(ip, '123456')

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ip.created_user.mail], email.to
  end
end
