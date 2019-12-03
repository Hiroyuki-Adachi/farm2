require 'test_helper'

class BroccoliSurveysControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "ブロッコリ調査" do
    get :index
    assert_response :success
  end

  test "ブロッコリ調査(検証者以外)" do
    session[:user_id] = users(:user_user).id
    get :index
    assert_response :error
  end
end
