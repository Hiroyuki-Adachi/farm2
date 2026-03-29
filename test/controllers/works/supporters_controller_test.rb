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

    assert_select "tbody tr.tr-total1" do |rows|
      assert rows.any? { |row| row.at("td:nth-child(1)")&.text&.strip == "2017年2月" }, "Expected a month total row with 2017年2月 in first column"
    end

    assert_select "tbody tr.tr-total2" do |rows|
      assert rows.any? { |row| row.at("td:nth-child(2)")&.text&.strip == "非組合員" }, "Expected a home subtotal row with 非組合員 in second column"
    end

    month_pos = response.body.index("2017年2月")
    home_pos = response.body.index("非組合員")
    assert month_pos.present? && home_pos.present? && month_pos < home_pos, "Expected month row to appear before home row"
  end
end
