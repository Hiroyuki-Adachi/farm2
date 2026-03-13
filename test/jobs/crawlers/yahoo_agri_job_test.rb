require "test_helper"

class Crawlers::YahooAgriJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      list: "news.yahoo.co.jp.media.agrinews.list.html",
      item: "news.yahoo.co.jp.articles.yahoo_agri.item.html"
    )

    travel_to Date.new(2025, 3, 10) do
      assert_difference "Topic.count", +1 do
        Crawlers::YahooAgriJob.perform_now
      end
    end

    assert_expected_topic
  end

  private

  def stub_pages(list:, item:)
    stub_request(:get, TopicType::YAHOO_AGRI.url).to_return(
      body: read_fixture(list)
    )
    stub_request(:get, "https://news.yahoo.co.jp/articles/test-yahoo-agri-article").to_return(
      body: read_fixture(item)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://news.yahoo.co.jp/articles/test-yahoo-agri-article", topic.url
    assert_equal TopicType::YAHOO_AGRI.id, topic.topic_type_id
    assert_equal Date.new(2025, 3, 9), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
    assert_includes topic.content, "続きの本文です"
  end
end
