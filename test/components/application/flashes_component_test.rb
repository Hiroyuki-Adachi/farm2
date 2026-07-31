require "test_helper"
require "view_component/test_case"

class Application::FlashesComponentTest < ViewComponent::TestCase
  test "noticeはsuccessアラートとして表示される" do
    render_inline(Application::FlashesComponent.new(flash: { notice: "保存しました" }))

    assert_selector("div.alert.alert-success.alert-dismissible.fade.show[role=alert]", text: "保存しました")
  end

  test "alertはwarningアラートとして表示される" do
    render_inline(Application::FlashesComponent.new(flash: { alert: "確認してください" }))

    assert_selector("div.alert.alert-warning", text: "確認してください")
  end

  test "errorはdangerアラートとして表示される" do
    render_inline(Application::FlashesComponent.new(flash: { error: "処理に失敗しました" }))

    assert_selector("div.alert.alert-danger", text: "処理に失敗しました")
  end

  test "未定義の種別はinfoアラートとして表示される" do
    render_inline(Application::FlashesComponent.new(flash: { status: "お知らせ" }))

    assert_selector("div.alert.alert-info", text: "お知らせ")
  end

  test "各flashに閉じるボタンが表示される" do
    render_inline(Application::FlashesComponent.new(flash: { notice: "保存しました", alert: "確認してください" }))

    assert_selector("div.alert", count: 2)
    assert_selector("button.btn-close[data-bs-dismiss=alert][aria-label=Close]", count: 2)
  end
end
