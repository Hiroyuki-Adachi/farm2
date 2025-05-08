class CrawlSmartAgriJob < CrawlJob
  queue_as :default

  def perform(words)
    agent = Mechanize.new
    search_all_agri_news(agent, words)
  end

  private

  def search_agri_news(agent, word)
    search_params = {count: 30, offset: 0, keyword: word}
    search_json = JSON.parse(agent.get("#{TopicType::SMART_AGRI.url}/api/v2/ajax/post", search_params).body, symbolize_names: true)

    search_json[:data][:posts].each do |topic|
      topic_date = Time.zone.parse(topic[:published]).to_date
      next if topic_date < Time.zone.today - START_DAY
      topic = save_topic(agent, "#{TopicType::SMART_AGRI.url}#{topic[:url]}", topic_date)
      save_user_topic(word, topic)
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
