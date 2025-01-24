require 'test_helper'

class PersonalInformations::OwnedRicesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(保有米)" do
    get personal_information_owned_rices_path(personal_information_token: @user.token)
    assert_response :success
  end
end
