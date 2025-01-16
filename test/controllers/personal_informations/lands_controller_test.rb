require 'test_helper'

class PersonalInformations::LandsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(土地)" do
    get personal_information_lands_path(personal_information_token: @user.token)
    assert_response :success
  end
end
