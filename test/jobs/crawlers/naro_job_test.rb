require "test_helper"

class Crawlers::NaroJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      list: "naro.go.jp.list.html",
      item: "naro.go.jp.item.html"
    )

    travel_to Date.new(2025, 5, 15) do
      assert_difference "Topic.count", +1 do
        Crawlers::NaroJob.perform_now
      end

      assert_expected_topic
    end
  end
  
  private

  def stub_pages(list:, item:)
    base_url = TopicType::NARO.url
    stub_request(:get, "#{base_url}/new_list.html").to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{#{Regexp.escape(base_url)}/project/research_activities/laboratory/carc/169353.html}).to_return(
      body: read_fixture(item)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    item_url = URI.join(TopicType::NARO.url, '/project/research_activities/laboratory/carc/169353.html').to_s
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal item_url, topic.url
    assert_equal TopicType::NARO.id, topic.topic_type_id
    assert_equal Date.new(2025, 5, 10), topic.posted_on
    assert_includes topic.content, '想定される記事の本文の一部'
  end
end
