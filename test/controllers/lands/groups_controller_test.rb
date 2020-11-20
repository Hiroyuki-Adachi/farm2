require 'test_helper'

class Lands::GroupsControllerTest <  ActionController::TestCase
  setup do
    setup_ip
    @member = lands(:lands1)
    @group = lands(:land_group1)
    @update = {
      place: "TEST", display_order: 1, area: 10
    }
  end

  test "土地グループ一覧" do
    get :index
    assert_response :success
  end

  test "土地グループ一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "土地グループ新規作成(表示)" do
    get :new
    assert_response :success
  end

  test "土地グループ新規作成(実行)" do
    assert_difference('Land.count') do
      post :create, params: {land: @update, members: [{land_id: @member.id, display_order: 1}]}
    end
    group = Land.last
    assert_equal true, group.group_flag
    assert_equal group.id, Land.find(@member.id).group_id

    assert_redirected_to lands_groups_path
  end

  test "土地グループ変更(表示)" do
    get :edit, params: {id: @group}
    assert_response :success
  end

  test "土地グループ変更(実行)" do
    assert_no_difference('Land.count') do
      patch :update, params: {id: @group, land: @update, members: []}
    end
    assert_redirected_to lands_groups_path
  end

  test "土地グループ削除" do
    member_id = @group.members[0].id
    assert_difference('Land.count', -1) do
      delete :destroy, params: {id: @group}
    end
    member = Land.find(member_id)
    assert_nil member.group_id
    assert_equal 0, member.group_order

    assert_redirected_to lands_groups_path
  end
end
