require "test_helper"

class Statistics::WorkersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get statistics_workers_index_url
    assert_response :success
  end
end
