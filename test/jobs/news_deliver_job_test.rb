require "test_helper"

class NewsDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_messages)
  end

  test "記事のLINE配信に成功した場合" do
    LineHookService.stubs(:push_messages).returns(Net::HTTPOK.new("1.1", "200", "OK"))

    perform_enqueued_jobs { NewsDeliverJob.perform_now }

    assert user_topics(:free_unread).reload.read_flag
  end

  test "記事のLINE配信でエラーが発生した場合" do
    LineHookService.stubs(:push_messages).returns(Net::HTTPServerError.new(1.0, "500", "Error"))
  
    perform_enqueued_jobs { NewsDeliverJob.perform_now }
  
    assert_not user_topics(:free_unread).reload.read_flag
  end
end
