require 'test_helper'

class Crawlers::AgriMyNaviJobTest < ActiveJob::TestCase
  test "クロールして記事を保存できる" do
    stub_pages(
      list: "agri.mynavi.jp.list.html",
      item: "agri.mynavi.jp.item.html"
    )

    travel_to Date.new(2025, 4, 10) do
      assert_difference "Topic.count", +1 do
        Crawlers::AgriMyNaviJob.perform_now
      end

      assert_expected_topic
    end
  end

  private

  def stub_pages(list:, item:)
    base_url = TopicType::AGRI_MY_NAVI.url
    stub_request(:get, "#{base_url}/news").to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{#{Regexp.escape(base_url)}/2025_04_09_310964/}).to_return(
      body: read_fixture(item)
    )
  end

  def read_fixture(filename)
    Rails.root.join("test/fixtures/html/#{filename}").read
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://agri.mynavi.jp/2025_04_09_310964/", topic.url
    assert_equal TopicType::AGRI_MY_NAVI.id, topic.topic_type_id
    assert_equal Date.new(2025, 4, 5), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
  end
end
