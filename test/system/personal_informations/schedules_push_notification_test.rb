require "application_system_test_case"

class PersonalInformations::SchedulesPushNotificationTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ページ表示直後はブラウザの通知許可ダイアログを要求せず、事前確認メッセージとボタンを表示する" do
    visit personal_information_schedules_path(@user.token)
    stub_notification_api

    assert_selector "[data-push-notification-panel]"
    assert_selector "[data-push-notification-enable]"
    sleep 0.5
    assert_equal 0, evaluate_script("window.__requestPermissionCalls.length")
  end

  test "「通知を有効化する」ボタンを押したときだけブラウザの通知許可ダイアログを要求する" do
    visit personal_information_schedules_path(@user.token)
    stub_notification_api
    sleep 0.5
    assert_equal 0, evaluate_script("window.__requestPermissionCalls.length")

    find("[data-push-notification-enable]").click

    assert_equal 1, evaluate_script("window.__requestPermissionCalls.length")
  end

  private

  # window.Notification をテスト用のダミーに差し替え、requestPermission が
  # 呼ばれた回数を window.__requestPermissionCalls に記録する。
  # このテスト環境は非セキュアコンテキストで navigator.serviceWorker が
  # 存在しないため、supported() を通すためにダミーを追加している。
  # page-loader の初期化(dynamic import)より先に評価されるよう、visit直後の
  # 同期scriptとして注入する(navigator.geolocationのスタブと同じ手法)。
  def stub_notification_api
    page.execute_script(<<~JS)
      window.__requestPermissionCalls = [];
      class FakeNotification {
        static permission = "default";
        static requestPermission() {
          window.__requestPermissionCalls.push(true);
          FakeNotification.permission = "denied";
          return Promise.resolve(FakeNotification.permission);
        }
      }
      Object.defineProperty(window, "Notification", { value: FakeNotification, configurable: true });
      if (!("serviceWorker" in navigator)) {
        Object.defineProperty(navigator, "serviceWorker", { value: {}, configurable: true });
      }
    JS
  end
end
