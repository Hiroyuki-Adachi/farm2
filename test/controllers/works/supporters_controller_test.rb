require "test_helper"

class Works::SupportersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get works_supporters_index_url
    assert_response :success
  end
end
