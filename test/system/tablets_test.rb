require "application_system_test_case"

class TabletsTest < ApplicationSystemTestCase
  test "/tablets/ ログイン画面表示" do
    visit "/tablets/"

    assert_text "タブレットログイン"
    assert_button "QRコードを生成"
  end
end
