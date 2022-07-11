require "test_helper"

class Sorimachi::AccountsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "ソリマチ科目初期化" do
    assert_difference('SorimachiAccount.count', sorimachi_accounts.count - 1) do
      get :new
    end
    assert_redirected_to sorimachi_imports_path
  end
end
