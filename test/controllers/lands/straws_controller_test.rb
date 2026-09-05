require "test_helper"

class Lands::StrawsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
  end

  test "稲わら一覧(初期表示)" do
    get lands_straws_path
    assert_response :success
  end

  test "年度選択肢に他組織の稲わら作業の年度を表示しない" do
    get lands_straws_path
    assert_response :success
    assert_select "select#term option[value=?]", "2099", count: 0
  end
end
