require "test_helper"

class UserNotificationTest < ActiveSupport::TestCase
  test "有効なメールアドレスの判定" do
    assert User.new(mail: "confirmed@example.com", mail_confirmed_at: Time.current).mailable?
    assert_not User.new(mail: "unconfirmed@example.com").mailable?
    assert_not User.new(mail: "", mail_confirmed_at: Time.current).mailable?
  end

  test "定期通知の配信先はLINE、メール、WEB Pushの順に選ばれる" do
    line_user = users(:user_line_id_already_exists)
    line_user.update!(mail: "line-and-mail@example.com")
    line_user.update!(mail_confirmed_at: Time.current)
    WebPushSubscription.create!(user: line_user, endpoint: "https://example.com/push/line", p256dh: "key",
                                auth: "auth")

    mail_user = users(:users1)
    WebPushSubscription.create!(user: mail_user, endpoint: "https://example.com/push/mail", p256dh: "key",
                                auth: "auth")

    web_user = users(:user_manager)
    WebPushSubscription.create!(user: web_user, endpoint: "https://example.com/push/web", p256dh: "key", auth: "auth")

    assert_includes User.linable, line_user
    assert_not_includes User.mail_notifiable, line_user
    assert_not_includes User.web_push_notifiable, line_user

    assert_includes User.mail_notifiable, mail_user
    assert_not_includes User.web_push_notifiable, mail_user

    assert_includes User.web_push_notifiable, web_user
  end

  test "配信はPCまたはスマートフォン向けのワードがあれば有効" do
    user = User.new(line_id: "")

    assert_not user.topic_delivery_enabled?

    user.user_words.build(word: "pc", pc_flag: true, sp_flag: false, line_flag: false)
    assert user.topic_delivery_enabled?

    user.user_words.clear
    user.user_words.build(word: "sp", pc_flag: false, sp_flag: true, line_flag: false)
    assert user.topic_delivery_enabled?
  end

  test "LINE向けだけのワードはLINE登録済みの場合のみ配信が有効" do
    user = User.new(line_id: "")
    user.user_words.build(word: "line", pc_flag: false, sp_flag: false, line_flag: true)

    assert_not user.topic_delivery_enabled?

    user.line_id = "U1234567890"
    assert user.topic_delivery_enabled?
  end

  test "すべての配信フラグが無効ならワードがあっても配信は無効" do
    user = User.new(line_id: "U1234567890")
    user.user_words.build(word: "disabled", pc_flag: false, sp_flag: false, line_flag: false)

    assert_not user.topic_delivery_enabled?
  end

  test "関連が未ロードなら全件をロードせずに配信を判定" do
    user = users(:users1)
    user.user_words.reset

    assert_not user.user_words.loaded?
    assert user.topic_delivery_enabled?
    assert_not user.user_words.loaded?
  end

  test "関連がロード済みならメモリ上で配信を判定" do
    user = users(:users1)
    user.user_words.load

    assert user.user_words.loaded?
    assert user.topic_delivery_enabled?
  end
end
