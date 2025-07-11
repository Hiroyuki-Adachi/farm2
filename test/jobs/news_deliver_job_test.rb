require "test_helper"

class NewsDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_messages)
  end

  test "記事のLINE配信に成功した場合" do
    LineHookService.define_singleton_method(:push_messages) do |_line_id, _messages|
      Net::HTTPOK.new("1.1", "200", "OK")
    end

    perform_enqueued_jobs { NewsDeliverJob.perform_now }

    assert user_topics(:free_unread).reload.read_flag
  end

  test "記事のLINE配信でエラーが発生した場合" do
    LineHookService.define_singleton_method(:push_messages) do |_line_id, _messages|
      Net::HTTPServerError.new(1.0, "500", "Error")
    end
  
    perform_enqueued_jobs { NewsDeliverJob.perform_now }
  
    assert_not user_topics(:free_unread).reload.read_flag
  end

  teardown do
    LineHookService.define_singleton_method(:push_messages, @original)
  end
end
