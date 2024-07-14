require "test_helper"

class Sessions::QrControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get sessions_qr_create_url
    assert_response :success
  end
end
