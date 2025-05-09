class CrawlJob < ApplicationJob
  queue_as :default

  START_DAY = 7

  def perform(perform_now: false)
    words = UserWord.words
    Topic.old(START_DAY).destroy_all
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

  # Associates a given topic with all users who have the specified word in their UserWord records.
  # 
  # @param word [String] The word to search for in UserWord records.
  # @param topic [Topic] The topic to associate with the users.
  # 
  # For each UserWord record matching the given word, this method creates or updates a UserTopic
  # record that links the user to the topic. It also copies the `pc_flag`, `sp_flag`, and `line_flag`
  # attributes from the UserWord record to the UserTopic record.
  def save_user_topic(word, topic)
    UserWord.where(word: word).find_each do |user_word|
      UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |user_topic|
        user_topic.word = word
        user_topic.pc_flag = user_word.pc_flag
        user_topic.sp_flag = user_word.sp_flag
        user_topic.line_flag = user_word.line_flag
      end
    end
  end

  def include_word?(text, word)
    normalize_text(text).include?(normalize_text(word))
  end
  
  def normalize_text(text)
    text.to_s.tr('　', ' ').gsub(/\s+/, '')
  end

  def self.ordered_classes
    [CrawlAgriNewsJob, CrawlAgriMyNaviJob, CrawlAgriJournalJob, CrawlSmartAgriJob, CrawlJaComJob, CrawlNousonNewsJob]
  end
end
