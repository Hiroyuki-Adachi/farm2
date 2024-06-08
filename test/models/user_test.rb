require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "メールアドレス変更" do
    user = users(:user_manager)
    user.mail = 'user@example.com'
    user.save!

    assert_not_nil user.mail_confirmation_token
    assert_not_nil user.mail_confirmation_expired_at
    assert_operator user.mail_confirmation_expired_at, :>, Time.current
    assert_nil user.mail_confirmed_at
  end
end
