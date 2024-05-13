class CrawlJob < ApplicationJob
  queue_as :default

  START_DAY = 7

  def perform(perform_now: false)
    words = UserWord.words
    if perform_now
      CrawlJob.ordered_classes.each {|job| job.perform_now(words) }
    else
      CrawlJob.ordered_classes.each {|job| job.perform_later(words) }
    end
  end

  def search_all_agri_news(agent, words)
    words.each do |word|
      search_agri_news(agent, word)
    end
  end

  def self.ordered_classes
    [CrawlAgriNewsJob, CrawlAgriMyNaviJob]
  end
end
