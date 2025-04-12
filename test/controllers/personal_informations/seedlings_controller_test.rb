require 'test_helper'

class PersonalInformations::SeedlingsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "個人情報(育苗)" do
    get personal_information_seedlings_path(personal_information_token: @user.token)
    assert_response :success
  end
end
