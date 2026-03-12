require "test_helper"

class PersonalInformations::TopicsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "TOPICS(一覧)" do
    get personal_information_topics_path(personal_information_token: @user.token)
    assert_response :success
    assert_match "検索ワード:", @response.body
    assert_match "word1", @response.body
    assert_match "word2", @response.body
  end

  test "TOPICS(既読)" do
    topic = user_topics(:user_topic1)
    assert_not topic.readed?

    patch personal_information_topic_path(personal_information_token: @user.token, id: topic.topic_id)
    assert_response :success

    topic.reload
    assert topic.readed?
  end
end
