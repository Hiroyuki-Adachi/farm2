require "test_helper"

class Lands::StrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "稲わら一覧(初期表示)" do
    get lands_straws_path
    assert_response :success
  end
end
