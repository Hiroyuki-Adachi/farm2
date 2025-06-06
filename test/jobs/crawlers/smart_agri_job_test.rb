require 'test_helper'

class Crawlers::SmartAgriJobTest < ActiveJob::TestCase
  test "クロールして記事を保存できる" do
    stub_pages(
      list: "smartagri-jp.com.list.json",
      item: "smartagri-jp.com.item.html"
    )

    travel_to Date.new(2025, 3, 10) do
      assert_difference "Topic.count", +1 do
        Crawlers::SmartAgriJob.perform_now
      end
    end

    assert_expected_topic
  end

  private

  def stub_pages(list:, item:)
    base_url = TopicType::SMART_AGRI.url
    stub_request(:get, %r{#{Regexp.escape(base_url)}/api/v2/ajax/post}).to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{#{Regexp.escape(base_url)}/food/10825}).to_return(
      body: read_fixture(item)
    )
  end

  def read_fixture(filename)
    Rails.root.join("test/fixtures/html/#{filename}").read
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://smartagri-jp.com/food/10825", topic.url
    assert_equal TopicType::SMART_AGRI.id, topic.topic_type_id
    assert_equal Date.new(2025, 3, 7), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
  end
end
