require "test_helper"

class Sessions::FacesControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get sessions_faces_create_url
    assert_response :success
  end
end
