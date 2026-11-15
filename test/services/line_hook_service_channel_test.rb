require "test_helper"

# #1243 送信元チャネルのアクセストークンを外から指定できる。省略時はグローバル設定を使う。
class LineHookServiceChannelTest < ActiveSupport::TestCase
  PUSH_URL = "https://api.line.me/v2/bot/message/push".freeze
  REPLY_URL = "https://api.line.me/v2/bot/message/reply".freeze

  setup do
    LineHookService.stubs(:default_channel_access_token).returns("global-token")
    @line_id = "U1234567890abcdef"
  end

  test "push_messageはチャネル指定時にそのアクセストークンで送る" do
    request = stub_request(:post, PUSH_URL).with(headers: { "Authorization" => "Bearer org-token" })

    LineHookService.push_message(@line_id, "テスト", channel_access_token: "org-token")

    assert_requested request
  end

  test "push_messageはチャネル未指定ならグローバル設定のアクセストークンで送る" do
    request = stub_request(:post, PUSH_URL).with(headers: { "Authorization" => "Bearer global-token" })

    LineHookService.push_message(@line_id, "テスト", retry_key: "key")

    assert_requested request
  end

  test "チャネルのアクセストークンが空ならグローバル設定にフォールバックする" do
    request = stub_request(:post, PUSH_URL).with(headers: { "Authorization" => "Bearer global-token" })

    LineHookService.push_messages(@line_id, ["テスト"], channel_access_token: "")

    assert_requested request
  end

  test "push_messagesはチャネル指定時にそのアクセストークンで送る" do
    request = stub_request(:post, PUSH_URL)
      .with(headers: { "Authorization" => "Bearer org-token", "X-Line-Retry-Key" => "key" })

    LineHookService.push_messages(@line_id, ["1", "2"], retry_key: "key", channel_access_token: "org-token")

    assert_requested request
  end

  test "send_replyはチャネル指定時とグローバル設定でアクセストークンを切り替える" do
    org_request = stub_request(:post, REPLY_URL).with(headers: { "Authorization" => "Bearer org-token" })
    global_request = stub_request(:post, REPLY_URL).with(headers: { "Authorization" => "Bearer global-token" })

    LineHookService.send_reply("reply-token", "テスト", channel_access_token: "org-token")
    LineHookService.send_reply("reply-token", "テスト")

    assert_requested org_request, times: 1
    assert_requested global_request, times: 1
  end

  test "Webhookの返信は初期化時に指定したチャネルで送る" do
    request = stub_request(:post, REPLY_URL).with(headers: { "Authorization" => "Bearer org-token" })
    user = users(:user_line_id_already_exists)

    assert LineHookService.new("hello", user.line_id, channel_access_token: "org-token").call("reply-token")

    assert_requested request
  end

  test "Webhookの返信は初期化時にチャネルを指定しなければグローバル設定で送る" do
    request = stub_request(:post, REPLY_URL).with(headers: { "Authorization" => "Bearer global-token" })
    user = users(:user_line_id_already_exists)

    assert LineHookService.new("hello", user.line_id).call("reply-token")

    assert_requested request
  end
end
