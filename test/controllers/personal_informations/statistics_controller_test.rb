require 'test_helper'

class PersonalInformations::StatisticsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get personal_informations_statistics_index_url
    assert_response :success
  end

end
