# test/channels/qr_login_channel_test.rb
require "test_helper"

class QrLoginChannelTest < ActionCable::Channel::TestCase
  test "tokenに対し購読とストリームが作成されること" do
    token = "test_token_123"
    subscribe token: token

    assert subscription.confirmed?
    assert_has_stream_for "qr_login:#{token}"
  end
end
