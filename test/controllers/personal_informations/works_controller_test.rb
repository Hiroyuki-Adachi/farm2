require 'test_helper'

class PersonalInformations::WorksControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "個人情報(日報)" do
    session[:user_id] = nil
    get :show, params: {personal_information_token: @worker.token, id: 1504}
    assert_response :success
  end
end
