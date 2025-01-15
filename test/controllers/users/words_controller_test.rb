require "test_helper"

class Users::WordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
    login_as(@user)
  end

  test "検索ワード(保守)(追加パターン)" do
    user_words = [{word: "test"}]
    assert_difference('UserWord.count', 1) do
      post users_words_path, params: { user: {user_words_attributes: user_words }}
    end
    assert_redirected_to new_users_word_path

    created_user_word = UserWord.last
    assert_equal user_words[0][:word], created_user_word.word
    assert_equal @user.id, created_user_word.user_id
  end

  test "検索ワード(保守)(空欄パターン)" do
    word1 = user_words(:words1)
    word2 = user_words(:words2)
    new_word2 = "TEST"
    assert_difference('UserWord.count', -1) do
      post users_words_path, params: { user: {user_words_attributes: [
        {id: word1.id, word: ""},
        {id: word2.id, word: new_word2}
      ] }}
    end
    assert_redirected_to new_users_word_path

    assert_nil UserWord.find_by(id: word1.id)
    word2.reload
    assert_equal new_word2, word2.word
  end

  test "検索ワード(保守)(重複パターン)" do
    word1 = user_words(:words1)
    word2 = user_words(:words2)
    new_word = "TEST"
    assert_raises(ActiveRecord::RecordNotUnique) do
      post users_words_path, params: { user: {user_words_attributes: [
        {id: word1.id, word: new_word},
        {id: word2.id, word: new_word}
      ] }}
    end
  end
end
