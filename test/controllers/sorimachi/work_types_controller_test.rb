require "test_helper"

class Sorimachi::WorkTypesControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @journal = sorimachi_journals(:journal1)
  end

  test "農業簿記内訳(表示)" do
    get :edit, params: {sorimachi_journal_id: @journal}
    assert_response :success
  end

  test "農業簿記内訳(更新)" do
    assert_difference('SorimachiWorkType.count') do
      put :update, params: {sorimachi_journal_id: @journal, 
                            sorimachi: {
                              work_types: {1 => 1},
                              amounts: {1 => 1000}
                            }}
    end
    assert_response :success
  end
end
