require 'test_helper'

class Sorimachi::ImportsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "農業簿記インポート(表示)" do
    get :index
    assert_response :success
  end

  test "農業簿記インポート(実行)" do
    SorimachiJournal.where(term: 2015).destroy_all
    assert_difference('SorimachiJournal.count', 2) do
      post :create, params: {import_file: fixture_file_upload(Rails.root.join("test/fixtures/files/sorimachi.csv").to_s, 'text/csv')}
    end
    assert_redirected_to sorimachi_imports_path
  end

  test "農業簿記フラグ設定" do
    journal = sorimachi_journals(:journal2)
    assert_no_difference('SorimachiJournal.count') do
      put :update, params: {id: journal.id}
    end
    assert SorimachiJournal.find(journal.id).cost0_flag
  end

  test "農業簿記フラグ削除" do
    journal = sorimachi_journals(:journal1)
    assert_no_difference('SorimachiJournal.count') do
      delete :destroy, params: {id: journal.id}
    end
    assert_not SorimachiJournal.find(journal.id).cost0_flag
  end
end
