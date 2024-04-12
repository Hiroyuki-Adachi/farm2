require 'test_helper'

class PersonalInformations::WorksControllerTest < ActionController::TestCase
  setup do
    @user = users(:users1)
  end

  test "個人情報(日報)" do
    session[:user_id] = nil
    get :show, params: {personal_information_token: @user.token, id: 1478}
    assert_response :success
  end
end
