require "test_helper"

class CrawlJobTest < ActiveJob::TestCase
  setup do
    @originals = CrawlJob.ordered_classes.map do |klass|
      [klass, klass.method(:perform_now), klass.method(:perform_later)]
    end
  end

  teardown do
    # 元のメソッドに戻す
    @originals.each do |klass, orig_now, orig_later|
      klass.define_singleton_method(:perform_now, orig_now)
      klass.define_singleton_method(:perform_later, orig_later)
    end
  end

  test "古いトピックが削除される" do
    old_topic = topics(:old_topic)
    new_topic = topics(:new_topic)

    assert Topic.exists?(old_topic.id)

    # CrawlJobsは空stubでOK
    CrawlJob.ordered_classes.each do |klass|
      klass.define_singleton_method(:perform_later) { |_| }
    end

    perform_enqueued_jobs { CrawlJob.perform_now }

    refute Topic.exists?(old_topic.id), "古いトピックが削除されるべき"
    assert Topic.exists?(new_topic.id), "新しいトピックは残るべき"
  end

  test "perform_now: true のとき perform_now が呼ばれる" do
    called = []
    CrawlJob.ordered_classes.each do |klass|
      klass.define_singleton_method(:perform_now) { |words| called << [klass.name, :now, words] }
    end

    perform_enqueued_jobs { CrawlJob.perform_now(perform_now: true) }

    assert_equal CrawlJob.ordered_classes.size, called.size
    assert called.all? { |entry| entry[1] == :now }, "全て perform_now が呼ばれるべき"
  end

  test "perform_now: false のとき perform_later が呼ばれる" do
    called = []
    CrawlJob.ordered_classes.each do |klass|
      klass.define_singleton_method(:perform_later) { |words| called << [klass.name, :later, words] }
    end

    perform_enqueued_jobs { CrawlJob.perform_now }

    assert_equal CrawlJob.ordered_classes.size, called.size
    assert called.all? { |entry| entry[1] == :later }, "全て perform_later が呼ばれるべき"
  end
end
