require "test_helper"

class PersonalInformations::Topics::WordsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:users1)
  end

  test "検索ワード保守画面" do
    get personal_information_edit_topics_words_path(personal_information_token: @user.token)
    assert_response :success
  end

  test "検索ワード保守(追加と空欄削除)" do
    word1 = user_words(:words1)
    word2 = user_words(:words2)

    assert_difference("UserWord.count", -1) do
      patch personal_information_topics_words_path(personal_information_token: @user.token), params: { user: { user_words_attributes: [
        { id: word1.id, word: "", pc_flag: true, sp_flag: true, line_flag: false },
        { id: word2.id, word: "topicword", pc_flag: true, sp_flag: true, line_flag: false }
      ] } }
    end

    assert_redirected_to personal_information_topics_path(personal_information_token: @user.token)
    assert_nil UserWord.find_by(id: word1.id)

    word2.reload
    assert_equal "topicword", word2.word
    assert word2.pc_flag
    assert word2.sp_flag
    assert_not word2.line_flag
  end

  test "検索ワード保守で他ユーザのワードは更新できない" do
    other_user_word = user_words(:other_user_word)

    assert_no_difference("UserWord.count") do
      patch personal_information_topics_words_path(personal_information_token: @user.token), params: { user: { user_words_attributes: [
        { id: other_user_word.id, word: "tampered-word" }
      ] } }
    end

    assert_response :service_unavailable
    assert_equal "other-word", other_user_word.reload.word
  end
end
