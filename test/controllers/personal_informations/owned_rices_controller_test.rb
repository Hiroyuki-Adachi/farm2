require 'test_helper'

class PersonalInformations::OwnedRicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get personal_informations_owned_rices_index_url
    assert_response :success
  end

end
