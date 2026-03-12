require 'test_helper'

class Crawlers::NousonNewsJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      top: "nouson-n.com.top.html",
      list: "nouson-n.com.list.html",
      item: "nouson-n.com.item.html"
    )

    travel_to Date.new(2025, 4, 10) do
      assert_difference "Topic.count", +1 do
        Crawlers::NousonNewsJob.perform_now
      end
    end

    assert_expected_topic
  end

  private

  def stub_pages(top:, list:, item:)
    base_url = TopicType::NOUSON_NEWS.url
    stub_request(:get, base_url).to_return(
      body: read_fixture(top)
    )
    stub_request(:get, %r{#{Regexp.escape(base_url)}/media/category/category02}).to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{https://www.nouson-n.com/media/2025/05/27/10142}).to_return(
      body: read_fixture(item)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://www.nouson-n.com/media/2025/05/27/10142", topic.url
    assert_equal TopicType::NOUSON_NEWS.id, topic.topic_type_id
    assert_equal Date.new(2025, 4, 8), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
  end
end
