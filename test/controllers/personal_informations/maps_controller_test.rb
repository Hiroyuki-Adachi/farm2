require "test_helper"

class PersonalInformations::MapsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "地図" do
    get personal_information_maps_path(personal_information_token: @user.token)
    assert_response :success
  end
end
