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

  # define_singleton_method で上書きすると後続のテストに残るため、テストごとに戻る mocha の stub を使う。
  def stub_push_messages
    called_flag = false
    LineHookService.stubs(:push_messages).with do |*|
      called_flag = true
    end.returns(Net::HTTPOK.new("1.1", "200", "OK"))
    -> { called_flag }
  end

  # #1244 組織にLINEチャネルがあればそのチャネルから送り、なければグローバル設定(nil)で送る
  test "組織のLINEチャネルが設定されていればそのアクセストークンで送る" do
    user = users(:user_line_id_already_exists)
    user.organization.update!(line_channel_access_token: "org-token-1244")

    assert_equal "org-token-1244", channel_token_for_news_reply(user, @word, :push_messages)
  end

  test "組織のLINEチャネルが未設定ならグローバル設定で送る" do
    user = users(:user_line_id_already_exists)
    user.organization.update!(line_channel_access_token: "")

    assert_nil channel_token_for_news_reply(user, @word, :push_messages)
  end

  test "記事が見つからない通知も組織のLINEチャネルから送る" do
    user = users(:user_line_id_already_exists)
    user.organization.update!(line_channel_access_token: "org-token-1244")

    assert_equal "org-token-1244", channel_token_for_news_reply(user, "該当なしのワード1244", :push_message)
  end

  private

  def channel_token_for_news_reply(user, word, method_name)
    tokens = []
    LineHookService.stubs(method_name).with do |_line_id, _messages, kwargs|
      tokens << kwargs[:channel_access_token]
      true
    end.returns(Net::HTTPOK.new("1.1", "200", "OK"))

    NewsReplyJob.perform_now(user.id, word)

    assert_equal 1, tokens.size, "#{method_name} が1回呼ばれるべき"
    tokens.first
  end
end
