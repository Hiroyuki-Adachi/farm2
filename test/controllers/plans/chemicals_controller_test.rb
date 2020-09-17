require 'test_helper'

class Plans::ChemicalsControllerTest < ActionController::TestCase
  setup do
    setup_ip
    session[:user_id] = users(:user_manager).id
  end

  test "薬剤計画(有無)(表示)" do
    get :new
    assert_response :success
  end

  test "薬剤計画(有無)(表示)(管理者以外)" do
    session[:user_id] = users(:user_checker).id
    get :new
    assert_response :error
  end  
end
