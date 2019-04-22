require 'test_helper'

class PersonalInformations::LandsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get personal_informations_lands_show_url
    assert_response :success
  end

end
