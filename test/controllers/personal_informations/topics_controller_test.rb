require "test_helper"

class PersonalInformations::TopicsControllerTest < ActionController::TestCase
  setup do
    @user = users(:users1)
  end

  test "TOPICS(一覧)" do
    session[:user_id] = nil
    get :index, params: {personal_information_token: @user.token}
    assert_response :success
  end

  test "TOPICS(明細)" do
    session[:user_id] = nil
    get :show, params: {personal_information_token: @user.token, id: topics(:topic1).id}
    assert_response :success
  end
end
