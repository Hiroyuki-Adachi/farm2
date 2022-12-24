require "test_helper"

class Gaps::CleaningsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work = works(:work_cleaning)
  end

  test "GAP清掃記録表(一覧)" do
    get :index
    assert_response :success
  end

  test "GAP清掃記録表(編集)" do
    get :edit, params: {id: @work}
    assert_response :success
  end

  test "GAP清掃記録表(更新)" do
    assert_difference('CleaningCleaningTarget.count') do
      assert_difference('CleaningInstitution.count') do
        assert_difference('Cleaning.count') do
          put :update, params: {id: @work, cleaning: {
            target: "TEST1",
            method: "TEST2",
            cleaning_target_ids: [1],
            institution_ids: [institutions(:jimusho).id]
          }}
        end
      end
    end
    assert_redirected_to gaps_cleanings_path
  end
end
