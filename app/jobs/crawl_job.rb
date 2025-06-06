class CrawlJob < ApplicationJob
  include NormalizesText
  queue_as :default

  START_DAY = 7

  def perform(perform_now: false)
    Topic.old(START_DAY).destroy_all
    if perform_now
      CrawlJob.ordered_classes.each {|job| job&.perform_now }
    else
      CrawlJob.ordered_classes.each {|job| job&.perform_later }
    end
    UserWord.match_all_topics!
  end

  def self.ordered_classes
    [
      Crawlers::AgriMyNaviJob,
      Crawlers::AgriJournalJob,
      Crawlers::SmartAgriJob,
      Crawlers::JaComJob,
      Crawlers::NousonNewsJob,
      Crawlers::NaroJob
    ]
  end
end
