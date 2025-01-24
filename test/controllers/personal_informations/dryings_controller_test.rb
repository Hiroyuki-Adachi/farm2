require 'test_helper'

class PersonalInformations::DryingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user31)
  end

  test "個人情報(乾燥調整)" do
    get personal_information_dryings_path(personal_information_token: @user.token)
    assert_response :success
  end
end
