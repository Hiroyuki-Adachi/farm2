require 'test_helper'

class PersonalInformationsControllerTest < ActionController::TestCase
  setup do
    @worker = workers(:worker1)
  end

  test "個人情報" do
    get :show, token: @worker.token
    assert_response :success
  end

end
