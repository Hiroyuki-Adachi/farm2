require "test_helper"

class CrawlJobTest < ActiveJob::TestCase
  test "perform_now モードで各ジョブが perform_now される" do
    CrawlJob.ordered_classes.each do |job_class|
      job_class.expects(:perform_now)
    end

    UserWord.expects(:match_all_topics!)
    Topic.expects(:old).with(CrawlJob::START_DAY).returns(Topic.none)

    CrawlJob.new.perform(perform_now: true)
  end

  test "perform_later モードで各ジョブが perform_later される" do
    CrawlJob.ordered_classes.each do |job_class|
      job_class.expects(:perform_later)
    end

    UserWord.expects(:match_all_topics!)
    Topic.expects(:old).with(CrawlJob::START_DAY).returns(Topic.none)

    CrawlJob.new.perform(perform_now: false)
  end

  test "古いトピックが削除される" do
    old_topics = mock("topics")
    old_topics.expects(:destroy_all)

    Topic.expects(:old).with(CrawlJob::START_DAY).returns(old_topics)
    CrawlJob.ordered_classes.each { |j| j.stubs(:perform_later) }
    UserWord.stubs(:match_all_topics!)

    CrawlJob.new.perform
  end
end
