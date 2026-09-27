require "application_system_test_case"

class PersonalInformations::ScansTest < ApplicationSystemTestCase
  setup do
    @user = users(:users1)
    visit new_personal_information_scan_path(personal_information_token: @user.token)
    assert_selector "#video"
    # カメラ入力のみ差し替え、実際のonScan・fetch・画面更新を実行する。
    page.execute_script <<~JS
      window.scanReady = false;
      import("qr-scanner").then(async ({ default: QrScanner }) => {
        QrScanner.prototype.start = function() {
          window.testScanner = this;
          return Promise.resolve();
        };
        const { init } = await import("pages/personal_informations/scans");
        init();
        window.scanReady = true;
      });
    JS
    assert_selector "#video"
    page.document.synchronize { raise Capybara::ElementNotFound unless page.evaluate_script("window.scanReady") }
  end

  test "圃場QRで圃場詳細に遷移する" do
    scan(lands(:lands1).uuid)
    assert_current_path personal_information_land_path(personal_information_token: @user.token, id: lands(:lands1).id)
  end

  test "不正UUIDでは該当なしを表示しスキャン画面を維持する" do
    scan("not-a-uuid")
    assert_selector "#popup_alert_message", text: "該当する圃場が見つかりません"
    assert_current_path new_personal_information_scan_path(personal_information_token: @user.token)
  end

  private

  def scan(value)
    page.execute_script("window.testScanner._onDecode({ data: arguments[0] })", { type: "lands", value: value }.to_json)
  end
end
