require "test_helper"

class Gaps::AccidentsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gaps_accidents_index_url
    assert_response :success
  end

  test "should get show" do
    get gaps_accidents_show_url
    assert_response :success
  end

  test "should get new" do
    get gaps_accidents_new_url
    assert_response :success
  end

  test "should get create" do
    get gaps_accidents_create_url
    assert_response :success
  end

  test "should get edit" do
    get gaps_accidents_edit_url
    assert_response :success
  end

  test "should get update" do
    get gaps_accidents_update_url
    assert_response :success
  end

  test "should get destroy" do
    get gaps_accidents_destroy_url
    assert_response :success
  end
end
