require 'test_helper'

class Sorimachi::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "農業簿記インポート(表示)" do
    get sorimachi_imports_path
    assert_response :success
    assert_select "input[type=radio][name=total_cost_type_id]", minimum: 1
    assert_select "input[type=radio][name=total_cost_type_id][checked=checked]", count: 1
    assert_select "th", text: "科目"
    assert_select "th", text: "金額"
    assert_select "th", text: "内訳", count: 0
    assert_select "button", text: "明細", count: 0
    assert_select "button", text: "内訳", count: 0
    assert_select "button", text: "計上", count: 0
    assert_select "button", text: "複写", count: 0
  end

  test "農業簿記インポート(種別絞り込み)" do
    get sorimachi_imports_path, params: {total_cost_type_id: TotalCostType::EXPENSEINDIRECT.id}
    assert_response :success
    assert_select "td", text: "荷造運賃"
    assert_select "td.numeric", text: "13,196"
  end

  test "農業簿記インポート(実行)" do
    csv_path = Rails.root.join("test/fixtures/files/sorimachi.csv").to_s
    csv_data = CSV.read(csv_path, encoding: "cp932", headers: SorimachiJournal.updatable_attributes, skip_lines: %r{^//})
    last_data = csv_data[-1]
    
    SorimachiJournal.where(term: @user.term).destroy_all
    assert_difference('SorimachiJournal.count', csv_data.size) do
      post sorimachi_imports_path, params: {import_file: fixture_file_upload(csv_path, 'text/csv')}
    end
    assert_redirected_to sorimachi_imports_path

    journal = SorimachiJournal.last
    assert_equal @user.term, journal.term
    last_data.headers.each do |header|
      journal_value = journal.send(header)
      if journal_value.nil?
        assert last_data[header].strip.empty?
      elsif journal_value.is_a?(Integer) || journal_value.is_a?(BigDecimal)
        assert_equal last_data[header].to_i, journal_value
      elsif journal_value.is_a?(Date)
        assert_equal Date.parse(last_data[header]), journal_value
      else
        assert_equal last_data[header], journal_value
      end
    end
  end

end
