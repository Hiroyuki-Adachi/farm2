require 'test_helper'

class PersonalInformations::WorksControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get personal_informations_works_show_url
    assert_response :success
  end

end
