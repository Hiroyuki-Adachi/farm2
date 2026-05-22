require 'test_helper'

class Crawlers::AgriJournalJobTest < ActiveJob::TestCase
  include CrawlersTestHelper

  test "クロールして記事を保存できる" do
    stub_pages(
      list: "agrijournal.jp.list.html",
      item1: "agrijournal.jp.item1.html",
      item2: "agrijournal.jp.item2.html"
    )

    travel_to Date.new(2026, 5, 28) do
      assert_difference "Topic.count", +1 do
        Crawlers::AgriJournalJob.perform_now
      end

      assert_expected_topic
    end
  end

  private

  def stub_pages(list:, item1:, item2:)
    base_url = TopicType::AGRI_JOURNAL.url
    stub_request(:get, "#{base_url}/allposts").to_return(
      body: read_fixture(list)
    )
    stub_request(:get, %r{https://agrijournal.jp/aj-market/92485/}).to_return(
      body: read_fixture(item1)
    )
    stub_request(:get, %r{https://agrijournal.jp/information/92442/}).to_return(
      body: read_fixture(item2)
    )
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "鈴木農相  5月22日記者会見「ナフサ由来製品の供給不安で、27日に業界団体と意見交換」", topic.title
    assert_equal "https://agrijournal.jp/aj-market/92485/", topic.url
    assert_equal TopicType::AGRI_JOURNAL.id, topic.topic_type_id
    assert_equal Date.new(2026, 5, 22), topic.posted_on
    assert_includes topic.content, "ナフサ由来の食品包装容器の変更が相次いでいる"
  end
end
