require 'test_helper'

class Crawlers::AgriJournalJobTest < ActiveJob::TestCase
  BODY = Struct.new(:body)

  test "クロールして記事を保存できる" do
    list_html = File.read(Rails.root.join("test/fixtures/html/agrijournal.jp.list.html"))
    item_html = File.read(Rails.root.join("test/fixtures/html/agrijournal.jp.item.html"))
    user_word = user_words(:words1)

    agent = stub(:get)
    agent.stubs(:get).with("#{TopicType::AGRI_JOURNAL.url}/news").returns(BODY.new(list_html))
    agent.stubs(:get).with(regexp_matches(%r{https://.+})).returns(BODY.new(item_html))

    travel_to Date.new(2024, 10, 25) do
      job = CrawlAgriJournalJob.new
      assert_difference "Topic.count", +1 do
        job.send(:search_all_agri_news, agent, [user_word.word])
      end
  
      last_topic = Topic.last
      assert_equal "想定される記事のタイトル", last_topic.title
      assert_equal "https://agrijournal.jp/information/75181/", last_topic.url
      assert_equal TopicType::AGRI_JOURNAL.id, last_topic.topic_type_id
      assert_equal Date.new(2024, 10, 21), last_topic.posted_on
      assert_includes last_topic.content, "想定される記事の本文の一部"
    end
  end
end
