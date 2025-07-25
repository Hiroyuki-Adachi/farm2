require 'test_helper'

class Crawlers::JaComJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      list: "jacom.or.jp.list.html",
      item: "jacom.or.jp.item.html"
    )

    travel_to Date.new(2025, 4, 10) do
      assert_difference "Topic.count", +1 do
        Crawlers::JaComJob.perform_now
      end

      assert_expected_topic
    end
  end

  private

  def stub_pages(list:, item:)
    base_url = TopicType::JA_COM.url
    stub_request(:get, "#{base_url}/news.php").to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{https://www.jacom.or.jp/column/2025/06/250605-82230.php}).to_return(
      body: read_fixture(item)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://www.jacom.or.jp/column/2025/06/250605-82230.php", topic.url
    assert_equal TopicType::JA_COM.id, topic.topic_type_id
    assert_equal Date.new(2025, 4, 9), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
  end
end
