require 'test_helper'

class ContractsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "受託作業一覧" do
    get contracts_path
    assert_response :success
  end

  test "受託作業一覧(管理者以外)" do
    login_as(users(:user_checker))
    get contracts_path
    assert_response :error
  end
end
