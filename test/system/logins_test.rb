require "application_system_test_case"

class LoginsTest < ApplicationSystemTestCase
  test "ログインページ表示" do
    visit root_path 
    assert_selector "#login_nam"
  end
end
