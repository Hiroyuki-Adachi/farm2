require 'test_helper'

class Sorimachi::ImportsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get sorimachi_imports_index_url
    assert_response :success
  end

  test "should get create" do
    get sorimachi_imports_create_url
    assert_response :success
  end

end
