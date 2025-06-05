require 'test_helper'

class Crawlers::AgriJournalJobTest < ActiveJob::TestCase
  test "クロールして記事を保存できる" do
    stub_pages(
      list: "agrijournal.jp.list.html",
      item1: "agrijournal.jp.item1.html",
      item2: "agrijournal.jp.item2.html"
    )

    travel_to Date.new(2024, 10, 25) do
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
    stub_request(:get, %r{https://agrijournal.jp/information/82779/}).to_return(
      body: read_fixture(item1)
    )
    stub_request(:get, %r{https://agrijournal.jp/renewableenergy/83364/}).to_return(
      body: read_fixture(item2)
    )
  end

  def read_fixture(filename)
    Rails.root.join("test/fixtures/html/#{filename}").read
  end

  def assert_expected_topic
    topic = Topic.last
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal "https://agrijournal.jp/information/82779/", topic.url
    assert_equal TopicType::AGRI_JOURNAL.id, topic.topic_type_id
    assert_equal Date.new(2024, 10, 21), topic.posted_on
    assert_includes topic.content, "想定される記事の本文の一部"
  end
end
