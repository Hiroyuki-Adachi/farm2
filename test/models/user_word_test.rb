# == Schema Information
#
# Table name: user_words(利用者ワード)
#
#  id                            :bigint           not null, primary key
#  line_flag(LINEフラグ)         :boolean          default(FALSE), not null
#  pc_flag(パソコンフラグ)       :boolean          default(TRUE), not null
#  sp_flag(スマートフォンフラグ) :boolean          default(TRUE), not null
#  word(ワード)                  :string(128)      default(""), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  user_id(利用者ID)             :integer          not null
#
# Indexes
#
#  index_user_words_on_word             (word)
#  index_user_words_on_word_by_user_id  (user_id,word) UNIQUE
#
require "test_helper"

class UserWordTest < ActiveSupport::TestCase
  test "マッチするトピックに対して UserTopic が作成される" do
    assert_difference "UserTopic.count", 2 do
      UserWord.match_all_topics!
    end

    user = users(:users1)
    user_word = user_words(:user_word_kinu)
    user_topic = UserTopic.find_by(user_id: user.id, topic_id: topics(:topic_kinu).id)

    assert user_topic
    assert_equal user_word.word, user_topic.word
    assert_equal user_word.pc_flag, user_topic.pc_flag
    assert_equal user_word.sp_flag, user_topic.sp_flag
    assert_equal user_word.line_flag, user_topic.line_flag

    user_word = user_words(:user_word_koshi)
    user_topic = UserTopic.find_by(user_id: user.id, topic_id: topics(:topic_koshi).id)
    assert user_topic
    assert_equal user_word.word, user_topic.word
    assert_equal user_word.pc_flag, user_topic.pc_flag
    assert_equal user_word.sp_flag, user_topic.sp_flag
    assert_equal user_word.line_flag, user_topic.line_flag
  end

  test "既に存在する UserTopic は重複作成されない" do
    # 1回目で作成
    UserWord.match_all_topics!
    # 2回目では増えないはず
    assert_no_difference "UserTopic.count" do
      UserWord.match_all_topics!
    end
  end
end
