require 'test_helper'

class PersonalInformations::StatisticsControllerTest < ActionController::TestCase
  setup do
    @user = users(:users1)
  end

  test "個人情報(集計)" do
    session[:user_id] = nil
    get :index, params: {personal_information_token: @user.token}
    assert_response :success
  end
end
