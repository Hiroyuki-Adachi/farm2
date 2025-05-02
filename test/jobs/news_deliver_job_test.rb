require "test_helper"

class NewsDeliverJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_message)
  end

  test "記事のLINE配信に成功した場合" do
    user_topic = user_topics(:free_unread)

    LineHookService.define_singleton_method(:push_message) do |*args|
      Net::HTTPServerError.new(1.0, "200", "OK")
    end

    perform_enqueued_jobs { NewsDeliverJob.perform_now }

    assert user_topic.reload.read_flag, "既読フラグが true になるはず"
  end

  test "有料記事の場合" do
    user_topic = user_topics(:paid_unread)

    LineHookService.stub :push_message, ->(*) { raise "should not be called" } do
      perform_enqueued_jobs { NewsDeliverJob.perform_now }
    end

    assert_not user_topic.reload.read_flag, "有料トピックは既読にしない"
  end

  test "記事のLINE配信でエラーが発生した場合" do
    user_topic = user_topics(:free_unread)
    user_topic.update!(read_flag: false)
  
    LineHookService.define_singleton_method(:push_message) do |*args|
      Net::HTTPServerError.new(1.0, "500", "Error")
    end
  
    perform_enqueued_jobs { NewsDeliverJob.perform_now }
  
    assert_not user_topic.reload.read_flag, "通知失敗時は既読にならない"
  end

  teardown do
    LineHookService.define_singleton_method(:push_message, @original)
  end
end
