require 'test_helper'

class SystemsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @system = systems(:s2015)
  end

  test "システム変更画面表示" do
    get :edit, params: {id: @system}
    assert_response :success
  end

  test "システム変更(システム管理者以外)" do
    session[:user_id] = users(:user_manager).id
    get :edit, params: {id: @system}
    assert_response :error
  end

  test "システム変更実行" do
    assert_no_difference('System.count') do
      patch :update, params: {id: @system, system: {dry_price: 1500}}
    end
    assert_redirected_to menu_index_path
  end
end
