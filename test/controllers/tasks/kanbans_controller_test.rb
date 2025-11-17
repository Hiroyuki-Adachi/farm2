require "test_helper"

class Tasks::KanbansControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get tasks_kanbans_show_url
    assert_response :success
  end

  test "should get update" do
    get tasks_kanbans_update_url
    assert_response :success
  end
end
