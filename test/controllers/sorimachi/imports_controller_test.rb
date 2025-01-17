require 'test_helper'

class Sorimachi::ImportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "農業簿記インポート(表示)" do
    get sorimachi_imports_path
    assert_response :success
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

  test "農業簿記フラグ設定" do
    journal = sorimachi_journals(:journal2)
    assert_no_difference('SorimachiJournal.count') do
      put sorimachi_import_path(id: journal.id)
    end
    assert SorimachiJournal.find(journal.id).cost0_flag
  end

  test "農業簿記フラグ削除" do
    journal = sorimachi_journals(:journal1)
    assert_no_difference('SorimachiJournal.count') do
      delete sorimachi_import_path(id: journal.id)
    end
    assert_not SorimachiJournal.find(journal.id).cost0_flag
  end
end
