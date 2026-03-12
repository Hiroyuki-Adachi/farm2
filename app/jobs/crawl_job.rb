class CrawlJob < ApplicationJob
  include NormalizesText
  include ParsesCrawlDate

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
      Crawlers::MaffGoJob,
      Crawlers::YahooAgriJob
    ]
  end

  private

  def run_crawlers(perform_now:)
    failures = []

    CrawlJob.ordered_classes.each do |job|
      next if job.nil?

      begin
        perform_now ? job.perform_now : job.perform_later
      rescue StandardError => e
        Rails.logger.error("[CrawlJob] #{job} failed: #{e.class} #{e.message}")
        failures << "[#{job}] #{e.class}: #{e.message}"
      end
    end

    raise StandardError, "One or more crawlers failed: #{failures.join('; ')}" if failures.any?
  end
end
