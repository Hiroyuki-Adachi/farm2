class CrawlJob < ApplicationJob
  include NormalizesText

  queue_as :default

  START_DAY = 7

  def perform(perform_now: false)
    Topic.old(START_DAY).destroy_all
    run_crawlers(perform_now: perform_now)
    UserWord.match_all_topics!
  end

  def self.ordered_classes
    [
      Crawlers::AgriMyNaviJob,
      Crawlers::AgriJournalJob,
      Crawlers::SmartAgriJob,
      Crawlers::JaComJob,
      Crawlers::NousonNewsJob,
      Crawlers::NaroJob,
      Crawlers::MaffGoJob
    ]
  end

  private

  def run_crawlers(perform_now:)
    CrawlJob.ordered_classes.each do |job|
      next if job.nil?

      perform_now ? job.perform_now : job.perform_later
    rescue StandardError => e
      Rails.logger.error("[CrawlJob] #{job} failed: #{e.class} #{e.message}")
    end
  end
end
