class CrawlSmartAgriJob < CrawlJob
  queue_as :default
  MY_AGRI_URL = TopicType::SMART_AGRI.url

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_params = {count: 30, offset: 0, keyword: word}
    search_json = JSON.parse(agent.get("#{MY_AGRI_URL}/api/v2/ajax/post", search_params).body, symbolize_names: true)

    search_json[:data][:posts].each do |topic|
      topic_date = Time.zone.parse(topic[:published]).to_date
      next if topic_date < Time.zone.today - START_DAY
      topic = save_topic(agent, "#{MY_AGRI_URL}#{topic[:url]}", topic_date)
      UserWord.where(word: word).find_each do |user_word|
        UserTopic.find_or_create_by(user_id: user_word.user_id, topic_id: topic.id) do |ut|
          ut.word = word
          assign_flags(ut, user_word)
        end
      end
    end
  end

  def save_topic(agent, url, topic_date)
    news_doc = Nokogiri::HTML(agent.get(url).body)
    return Topic.find_or_create_by(url: url) do |t|
      t.title = news_doc.css('h1.post-title').text.gsub(/\s+/, '')
      news_doc.css('div.editor-contents').css('br').each do |br|
        br.add_next_sibling(Nokogiri::XML::Text.new('　', news_doc))
      end
      t.content = news_doc.css('div.editor-contents').text.gsub(/\s+/, '').gsub("　　", "　")
      t.posted_on = topic_date
      t.topic_type_id = TopicType::SMART_AGRI.id
    end
  end
end
