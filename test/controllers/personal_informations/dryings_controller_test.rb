require 'test_helper'

class PersonalInformations::DryingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get personal_informations_dryings_index_url
    assert_response :success
  end

end
