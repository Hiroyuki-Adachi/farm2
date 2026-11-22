require "test_helper"

# #1244 組織のチャネルへ切り替える前に、利用者がそのチャネルを友だち追加しているか確認する
class LineHookServiceFriendTest < ActiveSupport::TestCase
  PROFILE_URL = "https://api.line.me/v2/bot/profile/U1234567890abcdef".freeze

  setup do
    @line_id = "U1234567890abcdef"
  end

  test "プロフィールが取得できれば友だち" do
    request = stub_request(:get, PROFILE_URL)
      .with(headers: { "Authorization" => "Bearer org-token" })
      .to_return(status: 200, body: "{}")

    assert LineHookService.friend?(@line_id, channel_access_token: "org-token")
    assert_requested request
  end

  test "404なら友だちではない(未追加・ブロック中)" do
    stub_request(:get, PROFILE_URL).to_return(status: 404, body: "{}")

    assert_not LineHookService.friend?(@line_id, channel_access_token: "org-token")
  end

  test "確認できないときは友だちではないものとして扱う" do
    stub_request(:get, PROFILE_URL).to_return(status: 500, body: "{}")
    assert_not LineHookService.friend?(@line_id, channel_access_token: "org-token")

    stub_request(:get, PROFILE_URL).to_timeout
    assert_not LineHookService.friend?(@line_id, channel_access_token: "org-token")
  end

  test "LINE IDかアクセストークンが空なら問い合わせない" do
    assert_not LineHookService.friend?("", channel_access_token: "org-token")
    assert_not LineHookService.friend?(@line_id, channel_access_token: "")
    assert_not_requested :get, PROFILE_URL
  end

  test "確認結果はキャッシュし、確認できなかったときはキャッシュしない" do
    Rails.stubs(:cache).returns(ActiveSupport::Cache::MemoryStore.new)

    stub_request(:get, PROFILE_URL).to_return(status: 500, body: "{}")
    assert_not LineHookService.friend?(@line_id, channel_access_token: "org-token")

    stub_request(:get, PROFILE_URL).to_return(status: 200, body: "{}")
    assert LineHookService.friend?(@line_id, channel_access_token: "org-token")
    assert LineHookService.friend?(@line_id, channel_access_token: "org-token")
    # 500 のときの1回と、200 を受け取った1回だけ。2回目の確認はキャッシュから返す
    assert_requested :get, PROFILE_URL, times: 2
  end
end
