require 'test_helper'

class Crawlers::JaComJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      list: "jacom.or.jp.latest.next.html",
      item: "jacom.or.jp.item.next.html"
    )

    travel_to Date.new(2026, 4, 17) do
      assert_difference "Topic.count", +1 do
        Crawlers::JaComJob.perform_now
      end

      assert_expected_topic
    end
  end

  private

  def stub_pages(list:, item:)
    base_url = TopicType::JA_COM.url
    stub_request(:get, "#{base_url}/latest").to_return(
      body: read_fixture(list)
    )
    stub_request(:get, "https://www.jacom.or.jp/jinji/mIr-gotDBpzZzt08EAk6_").to_return(
      body: read_fixture(item)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "【ＪＡ人事】ＪＡよいち（北海道）新組合長に梁瀬英司氏（4月13日）", topic.title
    assert_equal "https://www.jacom.or.jp/jinji/mIr-gotDBpzZzt08EAk6_", topic.url
    assert_equal TopicType::JA_COM.id, topic.topic_type_id
    assert_equal Date.new(2026, 4, 17), topic.posted_on
    assert_includes topic.content, "ＪＡよいち（北海道）は4月13日に第58回総会を開き、役員の改選を行った。"
  end
end
