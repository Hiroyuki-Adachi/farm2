require "test_helper"

class Sorimachi::WorkTypesControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get sorimachi_work_types_edit_url
    assert_response :success
  end
end
