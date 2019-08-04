require 'test_helper'

class TotalOwnedRicesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get total_owned_rices_index_url
    assert_response :success
  end

end
