require 'test_helper'

class MinutesControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "議事録一覧" do
    get :index
    assert_response :success
  end

  test "議事録一覧(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end

  test "議事録PDF参照(通常)" do
    get :show, params: {id: minutes(:minute1)}
    assert_response :success
  end

  test "議事録PDF参照(権限なし)" do
    session[:user_id] = nil
    get :show, params: {id: minutes(:minute1)}
    assert_response :error
  end

  test "議事録PDF参照(TOKEN)" do
    session[:user_id] = nil
    get :show, params: {token: workers(:worker1).token, id: minutes(:minute1)}
    assert_response :success
  end

  test "議事録削除" do
    assert_difference('Minute.count', -1) do
      delete :destroy, params: {id: minutes(:minute1)}
    end
    assert_redirected_to minutes_path
  end
end
