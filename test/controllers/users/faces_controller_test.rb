require "test_helper"

class Users::FacesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_faces_new_url
    assert_response :success
  end

  test "should get create" do
    get users_faces_create_url
    assert_response :success
  end
end
