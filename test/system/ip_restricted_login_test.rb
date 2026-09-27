require "application_system_test_case"

class IpRestrictedLoginTest < ApplicationSystemTestCase
  teardown do
    page.driver.headers = {}
  end

  test "ホワイトリスト登録済みのIPはログイン画面にアクセスできる" do
    page.driver.headers = { "X-Forwarded-For" => ip_lists(:ip_white).ip_address.to_s }

    visit root_path

    assert_selector '#login_name'
  end

  test "ブラックリスト登録済みのIPはログイン画面へのアクセスを拒否される" do
    page.driver.headers = { "X-Forwarded-For" => ip_lists(:ip_black).ip_address.to_s }

    visit root_path

    assert_text "Service Temporarily Unavailable"
    assert_no_selector '#login_name'
  end
end
