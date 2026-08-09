# frozen_string_literal: true

require "test_helper"

class WorkerDecoratorTest < ActiveSupport::TestCase
  # シンプルに new でOK（view コンテキストが不要なメソッドのみ）
  def decorate(model)
    WorkerDecorator.new(model)
  end

  test "#short_name は姓2文字＋(名頭1文字) を返す" do
    worker = Worker.new(family_name: "山田", first_name: "太郎")
    assert_equal "山田(太)", decorate(worker).short_name

    worker2 = Worker.new(family_name: "Li", first_name: "Hiro") # ASCII でもOK
    assert_equal "Li(H)", decorate(worker2).short_name

    # 1文字姓の端ケース
    worker3 = Worker.new(family_name: "王", first_name: "健")
    assert_equal "王(健)", decorate(worker3).short_name
  end

  test "#home_name は自宅名＋(名頭1文字)（当人が家長でない場合のみ）" do
    home_owner = Worker.new(id: 1, first_name: "太郎")
    home = Home.new(name: "A集落", worker_id: 1)
    home_owner.home = home

    # 家長＝自分 => カッコを付けない
    assert_equal "A集落", decorate(home_owner).home_name

    # 別人が家長 => (名頭1文字) を付ける
    guest = Worker.new(id: 2, first_name: "次郎")
    guest.home = home
    assert_equal "A集落(次)", decorate(guest).home_name
  end

  test "#disp_name は name と first_phonetic をまとめる" do
    worker = Worker.new(first_name: "太郎", family_name: "山田", first_phonetic: "たろう", family_phonetic: "やまだ")
    assert_equal "山田 太郎(たろう)", decorate(worker).disp_name
  end

  test "#permission_name は user 有無で分岐、I18n キーに従う" do
    with_user = Worker.new
    with_user.build_user(login_name: "taro", permission_id: :admin)
    assert_equal I18n.t("activerecord.enums.user.permission_ids.admin"), decorate(with_user).permission_name

    without_user = Worker.new
    assert_equal "", decorate(without_user).permission_name
  end

  test "#login_name は user がいればその login_name を返す" do
    w = Worker.new
    w.build_user(login_name: "taro")
    assert_equal "taro", decorate(w).login_name

    w2 = Worker.new
    assert_equal "", decorate(w2).login_name
  end

  test "通知状況は有効な項目に丸印を返す" do
    worker = workers(:worker1)

    assert_equal "", decorate(worker).line_mark
    assert_equal "◯", decorate(worker).mail_mark
    assert_equal "◯", decorate(worker).delivery_mark
  end

  test "OTPが有効なら丸印を返す" do
    worker = Worker.new
    worker.build_user(otp_enabled: true)

    assert_equal "◯", decorate(worker).otp_mark

    worker.user.otp_enabled = false
    assert_equal "", decorate(worker).otp_mark
  end

  test "ユーザがいない場合は通知状況を空欄にする" do
    worker = Worker.new

    assert_equal "", decorate(worker).line_mark
    assert_equal "", decorate(worker).mail_mark
    assert_equal "", decorate(worker).delivery_mark
    assert_equal "", decorate(worker).otp_mark
  end
end
