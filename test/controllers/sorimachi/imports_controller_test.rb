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
    assert_difference('SorimachiJournal.count', 2) do
      post :create, params: {import_file: fixture_file_upload("#{Rails.root}/test/fixtures/files/sorimachi.csv", 'text/csv')}
    end
    assert_redirected_to sorimachi_imports_path
  end
end
