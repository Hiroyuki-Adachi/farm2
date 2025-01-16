require "test_helper"

class Works::WholeCropsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @work = works(:work_wcs)
    login_as(users(:users1))
  end

  test "作業変更(WCS)(表示)" do
    get new_work_whole_crop_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(WCS)(変更)" do
    whole_crop = {
      work_id: @work.id,
      wcs_lands: [{
        work_land_id: work_lands(:work_land_wcs1).id,
        display_order: 1,
        rolls: 200,
        wcs_rolls: [
          {display_order: 1, weight: 290},
          {display_order: 2, weight: 300},
          {display_order: 3, weight: 295},
          {display_order: 4, weight: 298},
          {display_order: 5, weight: 295}
        ]
      }]
    }
    assert_difference("WholeCropRoll.count", 5) do
      assert_difference("WholeCropLand.count") do
        assert_difference('WorkWholeCrop.count') do
          post work_whole_crops_path(work_id: @work), params: {
            whole_crop: whole_crop
          }
        end
      end
    end
    assert_redirected_to work_path(id: @work)

    created_work_whole_crop = WorkWholeCrop.last
    assert_equal @work.id, created_work_whole_crop.work_id

    created_whole_crop_land = WholeCropLand.last
    assert_equal created_work_whole_crop.id, created_whole_crop_land.work_whole_crop_id
    assert_equal work_lands(:work_land_wcs1).id, created_whole_crop_land.work_land_id
    assert_equal whole_crop[:wcs_lands][0][:rolls], created_whole_crop_land.rolls

    created_whole_crop_rolls = WholeCropRoll.where(whole_crop_land_id: created_whole_crop_land.id).order(:display_order)
    assert_not_empty created_whole_crop_rolls
    created_whole_crop_rolls.each_with_index do |created_whole_crop_roll, index|
      assert_equal created_whole_crop_land.id, created_whole_crop_roll.whole_crop_land_id
      assert_equal whole_crop[:wcs_lands][0][:wcs_rolls][index][:weight], created_whole_crop_roll.weight
      assert_equal whole_crop[:wcs_lands][0][:wcs_rolls][index][:display_order], created_whole_crop_roll.display_order
    end
  end
end
