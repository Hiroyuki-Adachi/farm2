require 'test_helper'

class PersonalInformationsControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "個人情報" do
    session[:user_id] = nil
    get :show, params: {token: @worker.token}
    assert_response :success
  end
end
