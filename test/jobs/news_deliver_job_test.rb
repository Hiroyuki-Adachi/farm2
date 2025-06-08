require "test_helper"

class NewsDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_message)
  end

  test "記事のLINE配信に成功した場合" do
    free_user_topic = user_topics(:free_unread)

    LineHookService.define_singleton_method(:push_message) do |*args|
      Net::HTTPOK.new("1.1", "200", "OK")
    end

    perform_enqueued_jobs { NewsDeliverJob.perform_now }

    assert free_user_topic.reload.read_flag
  end

  test "記事のLINE配信でエラーが発生した場合" do
    free_user_topic = user_topics(:free_unread)
  
    LineHookService.define_singleton_method(:push_message) do |*args|
      Net::HTTPServerError.new(1.0, "500", "Error")
    end
  
    perform_enqueued_jobs { NewsDeliverJob.perform_now }
  
    assert_not free_user_topic.reload.read_flag
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end
end
