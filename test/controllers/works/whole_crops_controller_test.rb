require "test_helper"

class Works::WholeCropsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @work = works(:work_wcs)
  end

  test "作業変更(WCS)(表示)" do
    get :new, params: {work_id: @work}
    assert_response :success
  end

  test "作業変更(WCS)(変更)" do
    assert_difference("WholeCropRoll.count", 5) do
      assert_difference("WholeCropLand.count") do
        assert_difference('WorkWholeCrop.count') do
          post :create, params: {
            work_id: @work,
            whole_crop: {
              work_id: @work,
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
          }
        end
      end
    end
    assert_redirected_to work_path(id: @work)
  end
end
