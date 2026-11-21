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

  test "記事を確認済みメールアドレスへ配信した場合" do
    user_topic = user_topics(:user_topic1)
    mark_other_topics_as_read(user_topic)
    user_topic.update!(line_flag: false, mail_flag: true, read_flag: false)

    assert_difference -> { ActionMailer::Base.deliveries.size }, 1 do
      perform_enqueued_jobs { NewsDeliverJob.perform_now }
    end

    assert user_topic.reload.read_flag
    email = ActionMailer::Base.deliveries.last
    assert_equal [user_topic.user.mail], email.to
    assert_includes email.body.decoded, user_topic.topic.title
  end

  test "LINEとメールがどちらも有効な記事はLINEだけに配信する" do
    user = users(:user_line_id_already_exists)
    user.update!(mail: "line-news@example.com")
    user.update!(mail_confirmed_at: Time.current)
    user_topic = user_topics(:free_unread)
    user_topic.update!(line_flag: true, mail_flag: true, read_flag: false)
    LineHookService.stubs(:push_messages).returns(Net::HTTPOK.new("1.1", "200", "OK"))

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      perform_enqueued_jobs { NewsDeliverJob.perform_now }
    end

    assert user_topic.reload.read_flag
  end

  test "未確認メールアドレスには配信せず未読のままにする" do
    user_topic = user_topics(:user_topic1)
    mark_other_topics_as_read(user_topic)
    user_topic.user.update!(mail_confirmed_at: nil)
    user_topic.update!(line_flag: false, mail_flag: true, read_flag: false)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      perform_enqueued_jobs { NewsDeliverJob.perform_now }
    end

    assert_not user_topic.reload.read_flag
  end

  test "有料記事はメール配信せず未読のままにする" do
    user = users(:users1)
    user_topic = user_topics(:paid_unread)
    mark_other_topics_as_read(user_topic)
    user_topic.topic.update!(topic_type_id: 0)
    user_topic.update!(user: user, line_flag: false, mail_flag: true, read_flag: false)

    assert_no_difference -> { ActionMailer::Base.deliveries.size } do
      perform_enqueued_jobs { NewsDeliverJob.perform_now }
    end

    assert_not user_topic.reload.read_flag
  end

  test "配信可能チャネルがない利用者の記事は取得しない" do
    user_topic = user_topics(:user_topic1)
    mark_other_topics_as_read(user_topic)
    user_topic.update!(user: users(:user_manager), line_flag: true, mail_flag: true, read_flag: false)
    UserTopic.expects(:current_topics).never

    NewsDeliverJob.perform_now

    assert_not user_topic.reload.read_flag
  end

  # #1244 組織にLINEチャネルがあればそのチャネルから送り、なければグローバル設定(nil)で送る
  test "組織のLINEチャネルが設定されていればそのアクセストークンで送る" do
    users(:user_line_id_already_exists).organization.update!(line_channel_access_token: "org-token-1244")

    assert_equal "org-token-1244", channel_token_for_news_deliver
  end

  test "組織のLINEチャネルが未設定ならグローバル設定で送る" do
    users(:user_line_id_already_exists).organization.update!(line_channel_access_token: "")

    assert_nil channel_token_for_news_deliver
  end

  private

  def mark_other_topics_as_read(user_topic)
    UserTopic.where.not(id: user_topic.id).find_each { |topic| topic.update!(read_flag: true) }
  end

  def channel_token_for_news_deliver
    line_id = users(:user_line_id_already_exists).line_id
    tokens = {}
    LineHookService.stubs(:push_messages).with do |to, _messages, kwargs|
      tokens[to] = kwargs[:channel_access_token]
      true
    end.returns(Net::HTTPOK.new("1.1", "200", "OK"))

    NewsDeliverJob.perform_now

    assert tokens.key?(line_id), "push_messages が呼ばれるべき"
    tokens[line_id]
  end
end
