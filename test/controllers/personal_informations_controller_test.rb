require 'test_helper'

class PersonalInformationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報" do
    get personal_information_path(token: @user.token)
    assert_response :success
  end
end
