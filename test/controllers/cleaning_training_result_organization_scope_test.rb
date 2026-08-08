require "test_helper"

class CleaningTrainingResultOrganizationScopeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @other_organization = organizations(:org2)
    @other_work = works(:work_other_org)
    @other_worker = workers(:worker_other_org)
    login_as(users(:users1))
  end

  test "ヒヤリハット一覧に他組織の記録を含めない" do
    Accident.create!(
      work: @other_work, investigator: @other_worker, audience: @other_worker,
      accident_type_id: :rule, investigated_on: Date.new(2015, 5, 1),
      content: "別組織ヒヤリハット"
    )

    get gaps_accidents_path

    assert_response :success
    assert_not_includes response.body, "別組織ヒヤリハット"
  end

  test "ヒヤリハットに他組織の作業と作業者を登録できない" do
    attributes = {
      work_id: @other_work.id, investigator_id: @other_worker.id, audience_id: @other_worker.id,
      accident_type_id: :rule, investigated_on: Date.new(2015, 5, 1)
    }

    assert_no_difference("Accident.count") do
      post gaps_accidents_path, params: { accident: attributes }
    end
    assert_response :not_found
  end

  test "研修に他組織の講師と予定を登録できない" do
    other_schedule = Schedule.create!(
      organization: @other_organization, term: 2015, worked_at: Date.new(2015, 5, 1),
      work_kind: work_kinds(:work_kinds2),
      name: "別組織研修", work_flag: false, created_by: @other_worker.id
    )
    attributes = { worker_id: @other_worker.id, schedule_id: other_schedule.id, document: "越境" }

    assert_no_difference("Training.count") do
      put gaps_training_path(works(:work_study_create)), params: { training: attributes }
    end
    assert_response :not_found
  end

  test "WCS登録でパラメータの他組織作業へ付け替えない" do
    work = works(:work_wcs)
    attributes = {
      work_id: @other_work.id,
      wcs_lands: [{
        work_land_id: work_lands(:work_land_wcs1).id,
        display_order: 1,
        rolls: 1,
        wcs_rolls: [{ display_order: 1, weight: 100 }]
      }]
    }

    assert_difference("WorkWholeCrop.where(work_id: work.id).count") do
      assert_no_difference("WorkWholeCrop.where(work_id: @other_work.id).count") do
        post work_whole_crops_path(work_id: work), params: { whole_crop: attributes }
      end
    end
    assert_redirected_to work_path(id: work)
  end

  test "WCSロール更新で他組織のロールを指定できない" do
    other_whole_crop = WorkWholeCrop.create!(work: @other_work)
    other_work_land = WorkLand.create!(
      work: @other_work, land: lands(:land_other_org), display_order: 1
    )
    other_land = WholeCropLand.create!(
      work_whole_crop: other_whole_crop, work_land: other_work_land, display_order: 1
    )
    other_roll = WholeCropRoll.create!(wcs_land: other_land, display_order: 1, weight: 100)
    own_land = whole_crop_lands(:wcs_land1)
    attributes = {
      work_id: works(:work_wcs2).id,
      wcs_lands: [{
        id: own_land.id,
        work_land_id: own_land.work_land_id,
        display_order: own_land.display_order,
        rolls: own_land.rolls,
        wcs_rolls: [{ id: other_roll.id, display_order: 1, weight: 999 }]
      }]
    }

    post work_whole_crops_path(work_id: works(:work_wcs2)), params: { whole_crop: attributes }

    assert_response :not_found
    assert_equal 100, other_roll.reload.weight
    assert_equal other_land.id, other_roll.whole_crop_land_id
  end
end
