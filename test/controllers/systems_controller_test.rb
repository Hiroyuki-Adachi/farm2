require 'test_helper'

class SystemsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @system = systems(:s2015)
  end

  test "システム変更画面表示" do
    get edit_system_path(@system)
    assert_response :success
  end

  test "システム変更(システム管理者以外)" do
    login_as(users(:user_manager))
    get edit_system_path(@system)
    assert_response :error
  end

  test "システム変更実行" do
    assert_no_difference('System.count') do
      patch system_path(@system), params: {system: {dry_price: 1500}}
    end
    assert_redirected_to menu_index_path

    @system.reload
    assert_equal 1500, @system.dry_price
  end
end
