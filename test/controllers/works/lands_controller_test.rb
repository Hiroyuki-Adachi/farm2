require "test_helper"

class Works::LandsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    @user = users(:users1)
  end

  test "作業変更(土地)(表示)" do
    get :new, params: {work_id: works(:work_not_fixed)}
    assert_response :success

    get :new, params: {work_id: works(:work_fixed)}
    assert_redirected_to works_path
  end

  test "作業変更(土地)(変更)" do
    assert_difference('WorkLand.count', -1) do
      post :create, params: {work_id: works(:work_not_fixed), work_lands: [land_id: 1, display_order: 3], regist_lands: true}
    end
    assert_redirected_to work_path(id: works(:work_not_fixed))
  end
end
