require "test_helper"

class Users::LineHooksControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get users_line_hooks_create_url
    assert_response :success
  end
end
