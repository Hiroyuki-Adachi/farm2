require "test_helper"

class NewsReplyJobTest < ActiveJob::TestCase
  setup do
    @original = LineHookService.method(:push_messages)
    @topic = topics(:free_topic)
    @word = "free"

    stub_request(:head, @topic.url).to_return(status: 200)
  end

  teardown do
    LineHookService.define_singleton_method(:push_messages, @original)
  end

  test "ニュースのLINE配信に成功した場合" do
    user = users(:user_line_id_already_exists)

    called_args = nil
    LineHookService.define_singleton_method(:push_messages) do |line_id, messages|
      called_args = [line_id, messages]
      Net::HTTPOK.new("1.1", "200", "OK")
    end

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, @word)
    end

    assert user_topics(:free_unread).reload.read_flag
    assert_not called_args.nil?
    assert_equal user.line_id, called_args[0]
    assert_includes called_args[1][0], I18n.t('line_reply.topics_found')
    assert_includes called_args[1][1], @topic.url
    assert_includes called_args[1][1], @topic.posted_on.strftime('%y-%m-%d')
  end

  test "ユーザーが存在しない場合は何もしない" do
    was_called = stub_push_messages

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(-999, @word)
    end
    
    assert_not was_called.call
  end

  test "LINE未登録ユーザーには送信しない" do
    user = users(:user_line)
    was_called = stub_push_messages

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, @word)
    end

    assert_not was_called.call
  end

  test "トピックが0件の場合は送信しない" do
    user = users(:user_line_id_already_exists)
    word = "notfoundword"

    was_called = stub_push_messages

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, word)
    end

    assert_not was_called.call
  end

  test "URLが死んでいる場合はメッセージに含めない" do
    topic = topics(:dead_topic)
    stub_request(:head, topic.url).to_return(status: 404)

    user = users(:user_line_id_already_exists)
    word = "dead"

    was_called = stub_push_messages

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, word)
    end

    assert_not was_called.call
  end

  def stub_push_messages
    called_flag = false
    LineHookService.define_singleton_method(:push_messages) do |*|
      called_flag = true
      Net::HTTPOK.new("1.1", "200", "OK")
    end
    called_flag_ref = -> { called_flag }
    return called_flag_ref
  end
end
