require 'test_helper'

class RegistIpListTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user_line_id_already_exists)
    @ip_address = '5.5.5.5'
    @original = LineHookService.method(:push_message)
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end

  test "ID認証(LINEトークン取得→トークン認証)" do
    user_token = nil
    user_line_id = nil

    LineHookService.stubs(:push_message)
      .with do |line_id, message, kwargs|
        user_line_id = line_id
        user_token = message.split("\n").last.strip
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    post ip_lists_path, params: { login_name: @user.login_name }, headers: { 'REMOTE_ADDR' => @ip_address }
    ip = IpList.last
    assert_redirected_to edit_ip_list_path(ip)

    assert_equal @user.line_id, user_line_id
    assert_not_nil user_token

    patch ip_list_path(id: ip.id), params: {token: user_token}, headers: { 'REMOTE_ADDR' => @ip_address }
    assert_redirected_to menu_index_path
  end
end
