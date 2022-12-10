require "test_helper"

class Gaps::TrainingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gaps_trainings_index_url
    assert_response :success
  end

  test "should get show" do
    get gaps_trainings_show_url
    assert_response :success
  end

  test "should get edit" do
    get gaps_trainings_edit_url
    assert_response :success
  end

  test "should get update" do
    get gaps_trainings_update_url
    assert_response :success
  end

  test "should get destroy" do
    get gaps_trainings_destroy_url
    assert_response :success
  end
end
