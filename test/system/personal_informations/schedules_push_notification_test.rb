require "application_system_test_case"

class PersonalInformations::SchedulesPushNotificationTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
  end

  test "ページ表示直後はブラウザの通知許可ダイアログを要求せず、事前確認メッセージとボタンを表示する" do
    stub_notification_api

    visit personal_information_schedules_path(@user.token)

    assert_selector "[data-push-notification-panel]"
    assert_selector "[data-push-notification-enable]"
    assert_equal 0, evaluate_script("window.__requestPermissionCalls.length")
  end

  test "「通知を有効化する」ボタンを押したときだけブラウザの通知許可ダイアログを要求する" do
    stub_notification_api

    visit personal_information_schedules_path(@user.token)
    assert_equal 0, evaluate_script("window.__requestPermissionCalls.length")

    find("[data-push-notification-enable]").click

    assert_equal 1, evaluate_script("window.__requestPermissionCalls.length")
  end

  private

  # window.Notification をテスト用のダミーに差し替え、requestPermission が
  # 呼ばれた回数を window.__requestPermissionCalls に記録する。
  # このテスト環境は非セキュアコンテキストで navigator.serviceWorker が
  # 存在しないため、supported() を通すためにダミーを追加している。
  def stub_notification_api
    page.driver.browser.evaluate_on_new_document(<<~JS)
      (function () {
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
      })();
      void 0;
    JS
  end
end
