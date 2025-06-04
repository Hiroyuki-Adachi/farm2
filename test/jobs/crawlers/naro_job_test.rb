require "test_helper"

class Crawlers::NaroJobTest < ActiveJob::TestCase
  BODY = Struct.new(:body)

  test "クロールして記事を保存できる" do
    list_html = File.read(Rails.root.join("test/fixtures/html/naro.go.jp.list.html"))
    item_html = File.read(Rails.root.join("test/fixtures/html/naro.go.jp.item.html"))
    item_url = URI.join(TopicType::NARO.url, 'publicity_report/publication/laboratory/nire/news2/168994.html').to_s
    user_word = user_words(:words1)

    agent = stub(:get)
    agent.stubs(:get).with(URI.join(TopicType::NARO.url, 'new_list.html').to_s).returns(BODY.new(list_html))
    agent.stubs(:get).with(URI.join(TopicType::NARO.url, item_url).to_s).returns(BODY.new(item_html))

    travel_to Date.new(2025, 5, 15) do
      job = CrawlNaroJob.new
      assert_difference "Topic.count", +1 do
        assert_difference "UserTopic.count", +1 do
          job.send(:search_all_agri_news, agent, [user_word.word])
        end
      end

      last_topic = Topic.last
      assert_equal "想定される記事のタイトル", last_topic.title
      assert_equal item_url, last_topic.url
      assert_equal TopicType::NARO.id, last_topic.topic_type_id
      assert_equal Date.new(2025, 5, 10), last_topic.posted_on
      assert_includes last_topic.content, user_word.word

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
end
