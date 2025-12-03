require "test_helper"

class NewsReplyJobTest < ActiveJob::TestCase
  setup do
    @topic = topics(:free_topic)
    @word = "free"

    stub_request(:head, @topic.url).to_return(status: 200)
  end

  test "ニュースのLINE配信に成功した場合" do
    user = users(:user_line_id_already_exists)

    called_args = nil
    LineHookService.stubs(:push_messages)
      .with do |line_id, messages, kwargs|
        called_args = [line_id, messages]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

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

  test "トピックが0件の場合はエラーメッセージを送信する" do
    user = users(:user_line_id_already_exists)
    word = "notfoundword"

    called_args = nil
    LineHookService.stubs(:push_messages)
      .with do |line_id, messages, kwargs|
        called_args = [line_id, messages]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, word)
    end

    assert_not called_args.nil?
    assert_equal user.line_id, called_args[0]
    assert_includes called_args[1], I18n.t('line_reply.topics_not_found')
  end

  test "URLが死んでいる場合はエラーメッセージを送信する" do
    topic = topics(:dead_topic)
    stub_request(:head, topic.url).to_return(status: 404)

    user = users(:user_line_id_already_exists)
    word = "dead"

    called_args = nil
    LineHookService.stubs(:push_messages)
      .with do |line_id, messages, kwargs|
        called_args = [line_id, messages]
        # retry_key が付いてきてもOKにする
        kwargs[:retry_key].is_a?(String) || kwargs[:retry_key].nil?
      end
      .returns(Net::HTTPOK.new("1.1", "200", "OK"))

    perform_enqueued_jobs do
      NewsReplyJob.perform_now(user.id, word)
    end

    assert_not called_args.nil?
    assert_equal user.line_id, called_args[0]
    assert_includes called_args[1], I18n.t('line_reply.topics_not_found')
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
