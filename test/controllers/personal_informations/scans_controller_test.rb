require "test_helper"

class PersonalInformations::ScansControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get personal_informations_scans_index_url
    assert_response :success
  end
end
