require 'test_helper'

class TotalDryingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get total_dryings_index_url
    assert_response :success
  end

end
