require "test_helper"

class Users::WordsControllerTest < ActionController::TestCase
  setup do
    setup_ip
  end

  test "検索ワード(表示)" do
    get :new
    assert_response :success
  end

  test "検索ワード(保守)(追加パターン)" do
    assert_difference('UserWord.count', 1) do
      post :create, params: { user: {user_words_attributes: [
        {word: "test"}
      ] }}
    end
    assert_redirected_to new_users_word_path
  end

  test "検索ワード(保守)(空欄パターン)" do
    word1 = user_words(:words1)
    word2 = user_words(:words2)
    assert_difference('UserWord.count', -1) do
      post :create, params: { user: {user_words_attributes: [
        {id: word1.id, word: ""},
        {id: word2.id, word: "TEST"}
      ] }}
    end
    assert_redirected_to new_users_word_path
  end

  test "検索ワード(保守)(重複パターン)" do
    word1 = user_words(:words1)
    word2 = user_words(:words2)
    assert_raises(ActiveRecord::RecordNotUnique) do
      post :create, params: { user: {user_words_attributes: [
        {id: word1.id, word: "TEST"},
        {id: word2.id, word: "TEST"}
      ] }}
    end
  end
end
