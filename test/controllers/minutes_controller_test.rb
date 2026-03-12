require 'test_helper'

class MinutesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
    @minute = minutes(:minute1)
  end

  test "議事録一覧" do
    get minutes_path
    assert_response :success
  end

  test "議事録一覧(閲覧者はNG)" do
    login_as(users(:user_visitor))
    get minutes_path
    assert_response :error
  end

  test "議事録PDF参照(通常)" do
    get minute_path(@minute.id)
    assert_response :success
  end

  test "議事録PDF参照(権限なし)" do
    logout
    get minute_path(@minute.id)
    assert_response :error
  end

  test "議事録PDF参照(TOKEN)" do
    logout
    get minute_path(@minute.id), params: {token: @user.token}
    assert_response :success
  end

  test "議事録削除" do
    assert_difference('Minute.count', -1) do
      delete minute_path(@minute.id)
    end
    assert_redirected_to minutes_path

    assert_nil Minute.find_by(id: @minute.id)
  end
end
