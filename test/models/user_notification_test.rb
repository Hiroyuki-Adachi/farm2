require "test_helper"

class UserNotificationTest < ActiveSupport::TestCase
  test "有効なメールアドレスの判定" do
    assert User.new(mail: "confirmed@example.com", mail_confirmed_at: Time.current).mailable?
    assert_not User.new(mail: "unconfirmed@example.com").mailable?
    assert_not User.new(mail: "", mail_confirmed_at: Time.current).mailable?
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
