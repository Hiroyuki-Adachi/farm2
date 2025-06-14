require "test_helper"

class Crawlers::MaffGoJobTest < ActiveJob::TestCase
  test "クロールして記事を保存できる" do
    stub_pages(
      list: "maff.go.jp.list.html",
      item: "maff.go.jp.item.html"
    )

    travel_to Date.new(2025, 6, 15) do
      assert_difference "Topic.count", +1 do
        Crawlers::MaffGoJob.perform_now
      end

      assert_expected_topic
    end
  end
  
  private

  def stub_pages(list:, item:)
    base_url = TopicType::MAFF_GO.url
    stub_request(:get, URI.join(base_url, '/j/press/index.html').to_s).to_return(
      body: read_fixture(list)
    )
    stub_request(:get, URI.join(base_url, '/j/press/yusyutu_kokusai/chiiki/250613.html').to_s).to_return(
      body: read_fixture(item)
    )
  end

  def read_fixture(filename)
    Rails.root.join("test/fixtures/html/#{filename}").read
  end

  def assert_expected_topic
    topic = Topic.last
    item_url = URI.join(TopicType::MAFF_GO.url, '/j/press/yusyutu_kokusai/chiiki/250613.html').to_s
    assert_equal "想定される記事のタイトル", topic.title
    assert_equal item_url, topic.url
    assert_equal TopicType::MAFF_GO.id, topic.topic_type_id
    assert_equal Date.new(2025, 6, 13), topic.posted_on
    assert_includes topic.content, '想定される記事の本文の一部'
  end
end
