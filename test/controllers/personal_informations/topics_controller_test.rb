require "test_helper"

class PersonalInformations::TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "TOPICS(一覧)" do
    get personal_information_topics_path(personal_information_token: @user.token)
    assert_response :success
  end
end
