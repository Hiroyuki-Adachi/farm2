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

    # 作成された清掃データの確認
    created_cleaning = Cleaning.last
    assert_equal "TEST1", created_cleaning.target
    assert_equal "TEST2", created_cleaning.method
    assert_equal @work.id, created_cleaning.work_id

    # 作成された清掃施設の確認
    created_cleaning_institution = CleaningInstitution.last
    assert_equal institutions(:jimusho).id, created_cleaning_institution.institution_id
    assert_equal created_cleaning.id, created_cleaning_institution.cleaning_id

    # 作成された清掃対象の確認
    created_cleaning_target = CleaningCleaningTarget.last
    assert_equal 1, created_cleaning_target.cleaning_target_id
    assert_equal created_cleaning.id, created_cleaning_target.cleaning_id
  end
end
