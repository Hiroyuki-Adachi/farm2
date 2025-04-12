require "test_helper"

class Gaps::CleaningsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as(users(:users1))
    @work = works(:work_cleaning)
  end

  test "GAP清掃記録表(一覧)" do
    get gaps_cleanings_path
    assert_response :success
  end

  test "GAP清掃記録表(編集)" do
    get edit_gaps_cleaning_path(id: @work)
    assert_response :success
  end

  test "GAP清掃記録表(更新)" do
    cleaning = {
      target: "TEST1",
      method: "TEST2",
      cleaning_target_ids: [1],
      institution_ids: [institutions(:jimusho).id]
    }

    assert_difference('CleaningCleaningTarget.count') do
      assert_difference('CleaningInstitution.count') do
        assert_difference('Cleaning.count') do
          put gaps_cleaning_path(id: @work), params: {cleaning: cleaning}
        end
      end
    end
    assert_redirected_to gaps_cleanings_path

    # 作成された清掃データの確認
    created_cleaning = Cleaning.last
    assert_equal cleaning[:target], created_cleaning.target
    assert_equal cleaning[:method], created_cleaning.method
    assert_equal @work.id, created_cleaning.work_id

    # 作成された清掃施設の確認
    created_cleaning_institution = CleaningInstitution.last
    assert_equal cleaning[:institution_ids].first, created_cleaning_institution.institution_id
    assert_equal created_cleaning.id, created_cleaning_institution.cleaning_id

    # 作成された清掃対象の確認
    created_cleaning_target = CleaningCleaningTarget.last
    assert_equal cleaning[:cleaning_target_ids].first, created_cleaning_target.cleaning_target_id
    assert_equal created_cleaning.id, created_cleaning_target.cleaning_id
  end
end
