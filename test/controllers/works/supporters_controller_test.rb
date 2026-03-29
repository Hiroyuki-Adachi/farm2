require "test_helper"

class Works::SupportersControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:user2017))
  end

  test "外注集計一覧" do
    get works_supporters_url
    assert_response :success
    assert_select "h1", text: "外注集計一覧(2017)"
    assert_select "th", text: "作業月"
    assert_select "th", text: "世帯"
    assert_select "td", text: "2017年2月"
    assert_select "td", text: "非組合員"
    assert_operator response.body.index("2017年2月"), :<, response.body.index("非組合員")
  end
end
