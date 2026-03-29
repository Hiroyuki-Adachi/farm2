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
    assert_select "tbody tr" do |rows|
      assert rows.any? { |row|
        month_cell = row.at("td:nth-child(1)")&.text&.strip
        type_cell  = row.at("td:nth-child(2)")&.text&.strip
        month_cell == "2017年2月" && type_cell == "非組合員"
      }, "Expected a row with '2017年2月' in first column and '非組合員' in second column"
    end
  end
end
