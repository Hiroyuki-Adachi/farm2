require "test_helper"

class TopicWeeklyReportJobTest < ActiveJob::TestCase
  setup do
    Rails.application.credentials.stubs(:dig).with(:line, :secretariant_id).returns("fake-line-id")
  end

  test "topic_typeごとの件数を1メッセージで通知し0件を警告する" do
    job = TopicWeeklyReportJob.new
    topic_types = [TopicType.find(2), TopicType.find(3), TopicType.find(5)]

    job.stubs(:report_topic_types).returns(topic_types)
    Topic.stubs(:group).with(:topic_type_id).returns(stub(count: { 2 => 4, 5 => 1 }))

    captured = {}
    LineHookService.expects(:push_message).with do |*args|
      captured[:line_id] = args[0]
      captured[:message] = args[1]
      captured[:retry_key] = args[2][:retry_key]
      true
    end.once

    perform_enqueued_jobs { job.perform_now }

    assert_equal "fake-line-id", captured[:line_id]
    assert_includes captured[:message], "週次ニュース件数レポート"
    assert_includes captured[:message], "・マイナビ農業: 4件"
    assert_includes captured[:message], "・アグリジャーナル: 0件 ⚠️ニュース0件"
    assert_includes captured[:message], "・JA新聞: 1件"
    assert_not_nil captured[:retry_key]
  end

  test "通知先line_idが未設定なら送信しない" do
    Rails.application.credentials.stubs(:dig).with(:line, :secretariant_id).returns(nil)
    LineHookService.expects(:push_message).never

    perform_enqueued_jobs { TopicWeeklyReportJob.perform_now }
  end

  test "全トピックタイプが1件以上なら1行サマリを通知する" do
    job = TopicWeeklyReportJob.new
    topic_types = [TopicType.find(2), TopicType.find(3), TopicType.find(5)]

    job.stubs(:report_topic_types).returns(topic_types)
    Topic.stubs(:group).with(:topic_type_id).returns(stub(count: { 2 => 4, 3 => 2, 5 => 1 }))

    captured = {}
    LineHookService.expects(:push_message).with do |*args|
      captured[:message] = args[1]
      true
    end.once

    perform_enqueued_jobs { job.perform_now }

    assert_includes captured[:message], "全トピックタイプで1件以上を確認しました"
    assert_not_includes captured[:message], "・マイナビ農業:"
    assert_not_includes captured[:message], "⚠️ニュース0件"
  end
end
