require "test_helper"

class Works::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    @work = works(:work_not_fixed)
    login_as(@user)
  end

  test "作業変更(土地)(表示)" do
    get new_work_land_path(work_id: @work)
    assert_response :success
  end

  test "作業変更(土地)(表示)(確定済)" do
    get new_work_land_path(work_id: works(:work_fixed))
    assert_redirected_to works_path
  end

  test "作業変更(土地)(変更)" do
    land = lands(:lands0)
    work_lands = [{land_id: land.id, display_order: 3}]
    assert_difference('WorkLand.count', -1) do
      post work_lands_path(work_id: @work), params: {work_lands: work_lands, regist_lands: true}
    end
    assert_redirected_to work_path(id: @work)

    updated_work_lands = WorkLand.where(work_id: @work.id)
    assert_not_empty updated_work_lands
    assert_equal work_lands.size, updated_work_lands.count
    assert_equal @work.id, updated_work_lands[0].work_id
    assert_equal land.id, updated_work_lands[0].land_id
    assert_equal work_lands[0][:display_order], updated_work_lands[0].display_order
  end
end
