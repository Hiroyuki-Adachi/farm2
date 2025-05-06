require 'test_helper'

class CrawlAgriNewsJobTest < ActiveJob::TestCase
  BODY = Struct.new(:body)
  
  test "クロールして記事を保存できる" do
    list_html = File.read(Rails.root.join("test/fixtures/html/agrinews.co.jp.list.html"))
    item_html = File.read(Rails.root.join("test/fixtures/html/agrinews.co.jp.item.html"))
    user_word = user_words(:words1)

    search_params = {
      query: user_word.word,
      openDate: (Time.zone.today - 7).strftime('%Y-%m-%d'),
      closeDate: Time.zone.today.strftime('%Y-%m-%d')
    }

    agent = stub(:get)
    agent.stubs(:get).with("#{TopicType::AGRI_NEWS.url}/search", search_params).returns(BODY.new(list_html))
    agent.stubs(:get).with(regexp_matches(%r{https://.+})).returns(BODY.new(item_html))

    job = CrawlAgriNewsJob.new
    assert_difference "Topic.count", +1 do
      assert_difference "UserTopic.count", +1 do
        job.send(:search_all_agri_news, agent, [user_word.word])
      end
    end

    last_topic = Topic.last
    assert_equal "想定される記事のタイトル", last_topic.title
    assert_equal "https://www.agrinews.co.jp/news/prtimes/279550", last_topic.url
    assert_equal TopicType::AGRI_NEWS.id, last_topic.topic_type_id
    assert_equal Date.new(2024, 12, 26), last_topic.posted_on
    assert_includes last_topic.content, "想定される記事の本文の一部"

    last_user_topic = UserTopic.last
    assert_equal user_word.user_id, last_user_topic.user_id
    assert_equal last_topic.id, last_user_topic.topic_id
    assert_equal user_word.word, last_user_topic.word
    assert_not last_user_topic.read_flag
    assert_equal user_word.pc_flag, last_user_topic.pc_flag
    assert_equal user_word.sp_flag, last_user_topic.sp_flag
    assert_equal user_word.line_flag, last_user_topic.line_flag
  end
end
